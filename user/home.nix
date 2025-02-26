{
  setup,
  # outputs,
  lib,
  ...
}: {
  imports = let
    specific-imports =
      if setup.isNixOS
      then [
        ./ssh.nix
        ./xdg-portal.nix
      ]
      else [
        ./nixGL.nix
      ];
    chromium = lib.lists.optional (!setup.installFirefox) ./chromium.nix;
  in
    [
      ./alacritty.nix
      ./environment.nix
      ./ghostty.nix
      ./git.nix
      ./gtk.nix
      ./nh.nix
      ./neovim.nix
      ./packages.nix
      ./shells.nix
      ./windowmanager.nix
    ]
    ++ specific-imports
    ++ chromium;

  programs.home-manager.enable = true;

  home = {
    username = setup.username;
    homeDirectory = "/home/${setup.username}";
    stateVersion = setup.stateVersion;

    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      options = "caps:escape_shifted_capslock, compose:rctrl";
    };
  };
}
