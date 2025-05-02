{
  setup,
  lib,
  keyboard,
  ...
}: {
  imports = let
    specific-imports =
      if setup.isNixOS
      then [
        ./alacritty.nix
        ./gtk.nix
        ./ssh.nix
        ./xdg-portal.nix
      ]
      else [];
    chromium = lib.lists.optional (setup.installChromium) ./chromium.nix;
  in
    [
      ./environment.nix
      ./ghostty.nix
      ./git.nix
      ./neovim.nix
      ./nh.nix
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
    inherit keyboard;
  };
}
