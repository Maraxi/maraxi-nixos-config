# Hyprland setup shared by all hosts. Nothing here is specific to one machine: the host modules
# (hyprland-nixos.nix, hyprland-ubuntu.nix) add the host specific Hyprland config files, services and
# environment. The Hyprland config itself is in dotfiles/hypr/ (common.lua is shared, the host modules link
# hyprland.lua, hypridle.conf and hyprpaper.conf).
{
  config,
  inputs,
  lib,
  mutableLink,
  pkgs,
  setup,
  ...
}:
let
  # GTK has to scan every icon theme in XDG_DATA_DIRS at startup, which makes apps slow with the large
  # Papirus theme (~1s). The icon theme is Papirus-Dark globally. The few apps that need more fallback icons
  # or none at all get an adjusted environment instead.

  # Shadows the index.theme of Papirus-Dark with one that has more fallback themes. Only for waybar, which
  # needs the fallbacks for the icons of the window title and the tray.
  papirusFallback = pkgs.runCommand "papirus-dark-fallback" { } ''
    mkdir -p $out/share/icons/Papirus-Dark
    sed 's/^Inherits=.*/Inherits=breeze-dark,Yaru,Adwaita,hicolor/' \
      ${config.gtk.iconTheme.package}/share/icons/Papirus-Dark/index.theme \
      > $out/share/icons/Papirus-Dark/index.theme
  '';

  wrap =
    pkg: args:
    pkgs.symlinkJoin {
      name = "${pkg.pname or pkg.name}-wrapped";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/${pkg.meta.mainProgram} ${args}";
      meta.mainProgram = pkg.meta.mainProgram;
    };

  # Upstream's flaky sleeper_thread subprocess test has failed in the NixOS build sandbox, so skip the checks.
  waybar = wrap (inputs.waybar.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs
    (old: {
      doCheck = false;
      mesonFlags = (old.mesonFlags or [ ]) ++ [ "-Dtests=disabled" ];
    })
  ) "--prefix XDG_DATA_DIRS : ${papirusFallback}/share";

  # Satty needs none of the user's icon themes. On Ubuntu, skipping the Nix profile cuts ~0.6s from the
  # start of the screenshot editor.
  satty = wrap pkgs.satty (
    lib.optionalString (!setup.isNixOS) "--set XDG_DATA_DIRS /usr/share:/usr/local/share"
  );
in
{
  home.packages = [
    pkgs.grim
    pkgs.slurp
    satty
    pkgs.wf-recorder

    pkgs.wl-clipboard # wayland clipboard
    pkgs.wdisplays # arandr replacement
    # pkgs.kanshi # hot switching output profiles
    waybar
  ];

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
      export XCURSOR_THEME=${config.home.pointerCursor.name}
      export XCURSOR_SIZE=24
      export HYPRCURSOR_SIZE=24
    '';
  };
}
