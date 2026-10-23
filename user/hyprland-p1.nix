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
    # GNOME shell owns the notifications in the fallback session
    dunst = onlyInHyprland;
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

    # Only read by uwsm for Hyprland sessions
    "uwsm/env-hyprland".text = ''
      # Intel iGPU (internal panel) renders, the nvidia dGPU scans out the external monitors.
      # Colons inside the by-path names must be escaped with a backslash, hence the single quotes.
      export AQ_DRM_DEVICES='/dev/dri/by-path/pci-0000\:00\:02.0-card:/dev/dri/by-path/pci-0000\:01\:00.0-card'

      # Do NOT set LIBVA_DRIVER_NAME / __GLX_VENDOR_LIBRARY_NAME=nvidia: prime-select is on-demand,
      # apps should run on the Intel gpu unless started with offloading.

      export ELECTRON_OZONE_PLATFORM_HINT=auto
      export QT_QPA_PLATFORM="wayland;xcb"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    '';
  };
}
