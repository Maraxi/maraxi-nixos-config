{
  setup,
  keyboard,
  ...
}: {
  imports = let
    specific-imports =
      if setup.isNixOS
      then [
        ./alacritty.nix
        ./firefox.nix
        ./gtk.nix
        ./hyprland.nix
        ./podman.nix
        ./ssh.nix
        ./wayland-services.nix
        ./xdg-portal.nix
      ]
      else [
        # ./non-nixos.nix
        ./nixpkgs.nix
        ./windowmanager.nix
      ];
  in
    [
      ./environment.nix
      ./ghostty.nix
      ./git.nix
      ./keepassxc.nix
      ./meta.nix
      ./neovim.nix
      ./nh.nix
      ./packages.nix
      ./shells.nix
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
