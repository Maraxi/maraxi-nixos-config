# Hyprland on a non-NixOS host (Ubuntu + gdm, GNOME stays available as fallback session).
#
# Not used here on purpose:
# - wayland.windowManager.hyprland: it always generates ~/.config/hypr/hyprland.lua, but the config is a mutable link.
# - xdg.portal: it would put nix's xdg-desktop-portal frontend into the profile, which dbus would then also
#   pick in the GNOME session. Only the Hyprland backend (+ the Hyprland portal config) is installed.
#
# Root-level steps (session file for gdm) are in hosts/p1/, swaylock comes from apt.
{
  config,
  inputs,
  lib,
  mutableLink,
  pkgs,
  ...
}:
let
  profile = config.home.profileDirectory;

  # Services that must only run inside Hyprland, not in the GNOME fallback session.
  # uwsm imports HYPRLAND_INSTANCE_SIGNATURE into the systemd user environment before graphical-session.target.
  onlyInHyprland = {
    Unit.ConditionEnvironment = lib.mkForce [
      "WAYLAND_DISPLAY"
      "HYPRLAND_INSTANCE_SIGNATURE"
    ];
  };

  # Chromium/Electron apps (Edge, Teams, ...) open several token-less ScreenCast sessions for ONE screen
  # share (first for the preview in their own picker, then for the actual stream), so the portal picker
  # of xdg-desktop-portal-hyprland is shown again and again (GNOME hides this by silently restoring).
  # Wrapper around hyprland-share-picker: a follow-up request within a short time reuses the first
  # selection instead of asking again. Only the stdout selection layout is passed through unchanged.
  # See https://github.com/hyprwm/xdg-desktop-portal-hyprland/issues/385
  #
  # The picker itself is hyprland-preview-share-picker (previews of screens/windows, GTK). To go back to
  # the plain Qt picker of xdph use `${pkgs.xdg-desktop-portal-hyprland}/bin/hyprland-share-picker`.
  sharePicker = lib.getExe pkgs.hyprland-preview-share-picker;
  xdphSharePicker = pkgs.writeShellApplication {
    name = "xdph-share-picker-batched";
    runtimeInputs = with pkgs; [
      coreutils
      util-linux # logger
    ];
    text = ''
      ttl=60       # seconds a selection may be reused
      max_reuse=1  # follow-up requests per selection

      dir="$XDG_RUNTIME_DIR/xdph-share-picker-batched"
      mkdir -p "$dir"

      if [[ -s $dir/out && -s $dir/time && -s $dir/used ]]; then
        age=$(( $(date +%s) - $(cat "$dir/time") ))
        used=$(cat "$dir/used")
        if (( age <= ttl && used < max_reuse )); then
          echo $(( used + 1 )) > "$dir/used"
          logger -t xdph-share-picker-batched "reusing selection from $age s ago ($(( used + 1 ))/$max_reuse)"
          cat "$dir/out"
          exit 0
        fi
      fi

      rm -f "$dir/out" "$dir/time" "$dir/used"
      rc=0
      out=$(${sharePicker} "$@") || rc=$?
      if [[ $rc -eq 0 && $out == *"[SELECTION]"* ]]; then
        printf '%s\n' "$out" > "$dir/out"
        date +%s > "$dir/time"
        echo 0 > "$dir/used"
        logger -t xdph-share-picker-batched "new selection: $out"
      fi
      printf '%s\n' "$out"
      exit $rc
    '';
  };

  # Copied to /usr/share/wayland-sessions by hosts/p1/hyprland-session.sh.
  # Must be a real file there (the gdm user cannot read $HOME) with an Exec that survives GC and
  # new generations: the profile path is stable, a /nix/store path is not.
  # No TryExec: gdm checks it as the gdm user, who cannot read $HOME, and would hide the entry.
  session = pkgs.writeTextFile {
    name = "hyprland-nix-session";
    destination = "/share/wayland-sessions/hyprland-nix.desktop";
    text = ''
      [Desktop Entry]
      Name=Hyprland (nix, uwsm)
      Comment=An intelligent dynamic tiling Wayland compositor managed by uwsm
      Exec=${profile}/bin/uwsm start -e -D Hyprland -N Hyprland -F -- ${profile}/bin/start-hyprland
      DesktopNames=Hyprland
      Type=Application
    '';
  };
in
{
  imports = [ ./wayland.nix ]; # wl-clipboard, wdisplays, swaylock settings

  # nix' PAM cannot authenticate against the host: use `sudo apt install swaylock` (ships /etc/pam.d/swaylock)
  programs.swaylock.package = null;

  home.packages =
    with pkgs;
    [
      hyprland
      xdg-desktop-portal-hyprland
      uwsm
      session

      brightnessctl
      grim
      slurp
      satty
      wf-recorder
    ]
    ++ [ inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # Units shipped by the packages (uwsm templates, portal backend) -> ~/.local/share/systemd/user
  systemd.user.packages = with pkgs; [
    uwsm
    xdg-desktop-portal-hyprland
  ];

  services.hypridle.enable = true;
  services.hyprpaper.enable = true;
  services.hyprpolkitagent.enable = true;

  systemd.user.services = {
    hypridle = onlyInHyprland;
    hyprpaper = onlyInHyprland;
    hyprpolkitagent = onlyInHyprland;
    # Only in Hyprland: GNOME shell owns the notifications in the fallback session.
    # Restart: dunst 1.13.2 segfaults on notifications whose temporary icon file is already gone (Teams).
    dunst = onlyInHyprland // {
      Service = {
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
  };

  # dmenu like launcher
  programs.wofi = {
    enable = true;
    settings = {
      key_expand = "Left,Right";
    };
  };

  xdg.configFile = {
    "hypr/hyprland.lua" = mutableLink dotfiles/hypr-p1/hyprland.lua;
    "hypr/hypridle.conf" = mutableLink dotfiles/hypr-p1/hypridle.conf;
    "hypr/hyprpaper.conf" = mutableLink dotfiles/hypr-p1/hyprpaper.conf;
    "wofi/wallpaper" = mutableLink dotfiles/wofi-wallpaper;
    "waybar" = mutableLink dotfiles/waybar;
    "satty/config.toml" = mutableLink dotfiles/satty.toml;

    # aquamarine splits AQ_DRM_DEVICES at every ":" and does not support escaping, so the colons of the
    # /dev/dri/by-path names cannot be used directly. Colon-free links to the stable PCI paths instead
    # (PCI addresses: 00:02.0 = Intel UHD P630, 01:00.0 = Quadro T2000, see `lspci`).
    "hypr/card-intel".source =
      config.lib.file.mkOutOfStoreSymlink "/dev/dri/by-path/pci-0000:00:02.0-card";
    "hypr/card-nvidia".source =
      config.lib.file.mkOutOfStoreSymlink "/dev/dri/by-path/pci-0000:01:00.0-card";

    # Previews picker, https://github.com/WhySoBad/hyprland-preview-share-picker (stylesheets etc. possible)
    "hyprland-preview-share-picker/config.yaml".text = ''
      # screens first (default is windows)
      default_page: outputs
      # one click selects (default is 2)
      outputs:
        clicks: 1
      windows:
        clicks: 1
      # the restore token is of no use here (Chromium does not send one back)
      hide_token_restore: true
    '';

    "hypr/xdph.conf".text = ''
      screencopy {
        custom_picker_binary = ${lib.getExe xdphSharePicker}
      }
    '';

    # Only read by uwsm for Hyprland sessions
    "uwsm/env-hyprland".text = ''
      # Intel iGPU (internal panel) renders, the nvidia dGPU scans out the external monitors.
      export AQ_DRM_DEVICES="$HOME/.config/hypr/card-intel:$HOME/.config/hypr/card-nvidia"

      # Do NOT set LIBVA_DRIVER_NAME / __GLX_VENDOR_LIBRARY_NAME=nvidia: prime-select is on-demand,
      # apps should run on the Intel gpu unless started with offloading.

      export ELECTRON_OZONE_PLATFORM_HINT=auto
      export QT_QPA_PLATFORM="wayland;xcb"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';
  };
}
