{ setup, keyboard, ... }: {
  imports =
    let
      specific-imports =
        if setup.isNixOS then
          [
            ./alacritty.nix
            ./firefox.nix
            ./hyprland-nixos.nix
            ./nextcloud-sync.nix
            ./ssh.nix
          ]
        else
          [
            ./hyprland-ubuntu.nix
            ./nixpkgs.nix
            ./non-nixos.nix
            ./podman.nix
          ];
    in
    [
      ./cli-tools.nix
      ./dconf.nix
      ./environment.nix
      ./ghostty.nix
      ./git.nix
      ./gtk.nix
      ./hyprland.nix
      ./keepassxc.nix
      ./meta.nix
      ./mime.nix
      ./neovim.nix
      ./nh.nix
      ./notifications.nix
      ./packages.nix
      ./radio.nix
      ./shells.nix
    ]
    ++ specific-imports;

  programs.home-manager.enable = true;

  home = {
    inherit (setup) username;
    homeDirectory = "/home/${setup.username}";
    inherit (setup) stateVersion;
    inherit keyboard;
  };
}
