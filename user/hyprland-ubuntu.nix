# Hyprland on a non-NixOS host (Ubuntu + gdm, GNOME stays available as fallback session). Adds to the shared
# setup from hyprland.nix.
#
# Not used here on purpose:
# - wayland.windowManager.hyprland: it always generates ~/.config/hypr/hyprland.lua, but the config is a mutable link.
# - xdg.portal: it would put nix's xdg-desktop-portal frontend into the profile, which dbus would then also
#   pick in the GNOME session. Only the Hyprland backend (+ the Hyprland portal config) is installed.
#
# Root-level steps (session file for gdm) are in hosts/p1/, swaylock comes from apt.
{
  config,
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

  # Lock screen with fingerprint unlock. swaylock (apt, password via PAM) only starts PAM after a key press, so a
  # PAM fingerprint line needs an extra Enter first. Instead fprintd-verify runs in the background and
  # unlocks swaylock with SIGUSR1 as soon as the finger matches; the password works at any time.
  lockScreen = pkgs.writeShellApplication {
    name = "lock-screen";
    runtimeInputs = with pkgs; [
      coreutils
      procps # pidof, pkill
      hyprland # hyprctl
      brightnessctl
      gnugrep
    ];
    text = ''
      pidof swaylock >/dev/null && exit 0

      swaylock -f

      # swaylock has no feedback of its own for the fingerprint, so flash the LEDs: mute twice for a match,
      # micmute once for any failed read
      flash() {
        local led=$1 times=$2 i
        for ((i = 0; i < times; i++)); do
          brightnessctl -q -d "platform::$led" set 1 || true
          sleep 0.2
          brightnessctl -q -d "platform::$led" set 0 || true
          sleep 0.2
        done
      }

      # swaylock and fprintd-verify are the apt ones (/usr/bin)
      (
        while pidof swaylock >/dev/null; do
          # a verification waits for a finger, give up after a while to re-check that swaylock still runs
          out=$(timeout 20 fprintd-verify 2>&1) || true
          if grep -q 'verify-match' <<<"$out"; then
            pkill -USR1 swaylock
            # a touch on the sensor is no input that wakes a display that was switched off (lock keybinding, idle)
            hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' >/dev/null || true
            flash mute 2
            break
          elif grep -q 'Verify result: verify-' <<<"$out"; then
            flash micmute 2
          fi
          sleep 1
        done
      ) >/dev/null 2>&1 &
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
  # nix' PAM cannot authenticate against the host: use `sudo apt install swaylock` (ships /etc/pam.d/swaylock)
  programs.swaylock.package = null;

  home.packages = with pkgs; [
    hyprland
    xdg-desktop-portal-hyprland
    uwsm
    session
    lockScreen

    brightnessctl

    nerd-fonts.jetbrains-mono # waybar font + icons (NixOS gets it from system/fonts.nix)
  ];

  fonts.fontconfig.enable = true;

  # Units shipped by the packages (uwsm templates, portal backend) -> ~/.local/share/systemd/user
  systemd.user.packages = with pkgs; [
    uwsm
    xdg-desktop-portal-hyprland
  ];

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

  xdg.configFile = {
    "hypr/hyprland.lua" = mutableLink dotfiles/hypr/hyprland-p1.lua;
    "hypr/hypridle.conf" = mutableLink dotfiles/hypr/hypridle-p1.conf;
    "hypr/hyprpaper.conf" = mutableLink dotfiles/hypr/hyprpaper-p1.conf;

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

    "uwsm/env-hyprland".text = ''
      # Intel iGPU (internal panel) renders, the nvidia dGPU scans out the external monitors.
      export AQ_DRM_DEVICES="$HOME/.config/hypr/card-intel:$HOME/.config/hypr/card-nvidia"

      # Do NOT set LIBVA_DRIVER_NAME / __GLX_VENDOR_LIBRARY_NAME=nvidia (the NixOS desktop does):
      # this laptop is a hybrid system. The Intel iGPU renders and prime-select is on-demand, so apps should
      # run on the Intel gpu unless started with offloading. Forcing nvidia would wake the dGPU for every
      # GLX / VA-API app (battery) and make them render on a gpu that does not drive the internal panel.
      # The desktop has the nvidia card as its only gpu (user/hyprland-nixos.nix).

      export ELECTRON_OZONE_PLATFORM_HINT=auto
      export QT_QPA_PLATFORM="wayland;xcb"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';
  };
}
