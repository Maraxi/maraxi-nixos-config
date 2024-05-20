{
  pkgs,
  inputs,
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
    librewolf
    thunderbird
    keepassxc
    mako # wayland notification daemon
    sway-contrib.grimshot
    # grim
    # slurp # wayland screenshots
    # wf-recorder
    # kanshi # hot switching output profiles
    wl-clipboard # wayland clipboard
    # shotman # wayland screenshots
    # flameshot
    simple-scan
    tree
    ripgrep
    fd
    feh
    glances
    python313
    neofetch
    htop
    btop
    fclones
    pciutils
    wget
    lsof
    alejandra
    pavucontrol
    # hello
    appimage-run
  ];
  home.sessionPath = ["$HOME/bin"];

  programs.nixvim.enable = true;
  programs.nixvim = {
    opts = {
      number = true;
      relativenumber = true;
      list = true;
    };
  };

  gtk = {
    enable = true;
    # gtk3.extraConfig.gtk-decoration-layout = "menu:";
    # theme.package = pkgs.solarc-gtk-theme;
    # theme.name = "SolArc-Dark";
    # theme = {
    # name = "Storm-B";
    # package = pkgs.tokyonight-gtk-theme;
    # };
    # iconTheme.name = "Tokyonight-Moon";
    # cursorTheme = {
    # name = "gtkCursorTheme";
    # package = pkgs.bibata-cursors;
    # };
  };
  # home.sessionVariables.GTK_THEME = "Tokyonight-Moon";
  programs.git = {
    enable = true;
    userName = "Maraxi";
    userEmail = "Maraxi@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  # programs.ssh = {
  # enable = true;
  # matchBlocks = {
  # "github.com" = {
  # hostname = "github.com";
  # identityFile = "/home/stefan/.ssh/id_ed25519_github";
  # };
  # };
  # };

  home.stateVersion = "24.05";
}
