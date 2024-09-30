{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../user/alacritty.nix
    ../../user/environment.nix
    ../../user/git.nix
    ../../user/gtk.nix
    ../../user/packages.nix
    ../../user/shells.nix
    ../../user/sway.nix
  ];

  nixpkgs = {
    overlays = [
      # outputs.overlays.trunk-packages
    ];
  };

  programs.home-manager.enable = true;

  home = {
    username = "stefan";
    homeDirectory = "/home/stefan";
    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      options = "caps:escape_shifted_capslock, compose:rctrl";
    };
    stateVersion = "24.05";
  };

  # xdg-portals for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-wlr];
    config = {
      common.default = ["wlr"];
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
}
