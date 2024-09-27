{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../user/alacritty.nix
    ../../user/environment.nix
    ../../user/sway.nix
    ../../user/shells.nix
    ../../user/git.nix
    ../../user/gtk.nix
    ../../user/packages.nix
  ];
  programs.home-manager.enable = true;

  home.username = "stefan";
  home.homeDirectory = "/home/stefan";
  home.keyboard = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape_shifted_capslock";
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--max-columns-preview"
      "--max-columns=80"
    ];
  };

  # xdg-portals for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config = {
      common.default = ["wlr"];
    };
  };

  dconf.settings = {
    "org/nemo/preferences" = {
      show-hidden-files = true;
      thumbnail-limit = lib.hm.gvariant.mkUint64 1073741824;
    };
  };

  programs.ssh = {
    enable = true;
    compression = true;
    matchBlocks = {
      "pi" = {
        hostname = "192.168.178.45";
        user = "stefan";
        port = 36969;
        identityFile = "/home/stefan/.ssh/id_ed25519_raspberrypi";
      };
      "github.com" = {
        identityFile = "/home/stefan/.ssh/id_ed25519_github";
      };
    };
  };

  home.stateVersion = "24.05";
}
