{
  setup,
  outputs,
  ...
}: {
  imports = let
    specific-imports =
      if setup.isNixOS
      then [
        ./sway.nix
        ./ssh.nix
        ./xdg-portal.nix
      ]
      else [
        ./chromium.nix
        ./nixGL.nix
        (builtins.fetchurl {
          url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
          sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
        })
      ];
  in
    [
      ./alacritty.nix
      ./environment.nix
      ./git.nix
      ./gtk.nix
      ./packages.nix
      ./shells.nix
    ]
    ++ specific-imports;

  programs.home-manager.enable = true;

  # nixpkgs = {
  # overlays = [
  # outputs.overlays.selective-update
  # ];
  # };

  home = {
    username = setup.username;
    homeDirectory = "/home/" + setup.username;
    stateVersion = setup.stateVersion;

    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      options = "caps:escape_shifted_capslock, compose:rctrl";
    };
  };
}
