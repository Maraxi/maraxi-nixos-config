{
  pkgs,
  inputs,
  lib,
  ...
}:
# let
# nixvim = import (builtins.fetchGit {
# url = "https://github.com/nix-community/nixvim";
# If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
# ref = "nixos-23.05";
# });
# in
{
  imports = [
    ../../user/alacritty.nix
    ../../user/sway.nix
    ../../user/shells.nix
    ../../user/git.nix
  ];
  programs.home-manager.enable = true;

  home.username = "stefan";
  home.homeDirectory = "/home/stefan";
  home.keyboard = {
    layout = "de";
    variant = "nodeadkeys";
    options = "caps:escape_shifted_capslock";
  };
  home.packages = with pkgs; [
    cinnamon.nemo
    xfce.thunar
    librewolf
    thunderbird
    keepassxc
    simple-scan
    feh

    appimage-run
    pavucontrol

    python313

    glances
    htop
    btop

    tree
    ripgrep
    fd
    neofetch
    fclones
    pciutils
    wget
    lsof
    atool
    unzip
    zip
    alejandra
  ];
  home.sessionPath = ["$HOME/bin"];

  # programs.nixvim.enable = true;
  # programs.nixvim = {
    # opts = {
      # number = true;
      # relativenumber = true;
      # list = true;
    # };
  # };

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

  # catppuccin.enable = true;
  gtk.enable = true;
  gtk.catppuccin = {
    enable = true;
    icon.enable = true;
  };

  # catppuccin.pointerCursor.enable = true;
  # catppuccin.pointerCursor.accent = "pink";
  catppuccin.flavor = "mocha";

  # home.pointerCursor = {
  # gtk.enable = true;
  # name = "Catppuccin-Mocha-Dark-Cursors";
  # package = pkgs.catppuccin-cursors.mochaDark;
  # size = 16;
  # };

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
