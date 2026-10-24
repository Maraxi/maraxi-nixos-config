# Hyprland setup shared by all hosts. Nothing here is specific to one machine: the host modules
# (hyprland-nixos.nix, hyprland-ubuntu.nix) add the host specific Hyprland config files, services and
# environment. The Hyprland config itself is in dotfiles/hypr/ (common.lua is shared, the host modules link
# hyprland.lua, hypridle.conf and hyprpaper.conf).
{
  inputs,
  mutableLink,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [
      grim
      slurp
      satty
      wf-recorder

      wl-clipboard # wayland clipboard
      wdisplays # arandr replacement
      # kanshi # hot switching output profiles
    ]
    ++ [ inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  # dmenu like launcher
  programs.wofi = {
    enable = true;
    settings = {
      key_expand = "Left,Right";
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 100;
      indicator-thickness = 15;
      line-color = "000000";
      show-failed-attempts = true;
      ignore-empty-password = true;
    };
  };

  services.hypridle.enable = true;

  xdg.configFile = {
    "hypr/common.lua" = mutableLink dotfiles/hypr/common.lua;
    "hypr/.luarc.json" = mutableLink dotfiles/hypr/.luarc.json;
    "wofi/wallpaper" = mutableLink dotfiles/wofi-wallpaper;
    "waybar" = mutableLink dotfiles/waybar;
    "satty/config.toml" = mutableLink dotfiles/satty.toml;

    # Only read by uwsm for Hyprland sessions (it also imports the environment into systemd and dbus,
    # so Hyprland needs neither hl.env() nor dbus-update-activation-environment). The host modules append
    # their variables. Read at login, a session restart is needed after changes.
    "uwsm/env-hyprland".text = ''
      export XCURSOR_SIZE=24
      export HYPRCURSOR_SIZE=24
    '';
  };
}
