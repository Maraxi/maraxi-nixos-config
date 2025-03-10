{
  setup,
  keyboard,
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
    ++ specific-imports;

  programs.home-manager.enable = true;

  home = {
    username = setup.username;
    homeDirectory = "/home/${setup.username}";
    stateVersion = setup.stateVersion;
    inherit keyboard;
  };
}
