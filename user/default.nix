{ setup, keyboard, ... }: {
  imports =
    let
      specific-imports =
        if setup.isNixOS then
          [
            ./nixos/alacritty.nix
            ./nixos/firefox.nix
            ./nixos/hyprland.nix
            ./nixos/nextcloud-sync.nix
            ./nixos/ssh.nix
          ]
        else
          [
            ./non-nixos/dix.nix
            ./non-nixos/ecc.nix
            ./non-nixos/hyprland.nix
            ./non-nixos/nixpkgs.nix
            ./non-nixos/nvidia.nix
            ./non-nixos/podman.nix
            ./non-nixos/remmina.nix
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
      ./thunar.nix
      ./tmux.nix
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
