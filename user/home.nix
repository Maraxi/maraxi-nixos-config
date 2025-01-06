{
  setup,
  # outputs,
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
        ./chromium.nix
        ./nixGL.nix
      ];
  in
    [
      ./alacritty.nix
      ./environment.nix
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

  nixpkgs =
    if setup.isNixOS
    then {}
    else {
      overlays = [
        # outputs.overlays.selective-update
      ];
    };

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
