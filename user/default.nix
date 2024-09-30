{
  inputs,
  setup,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./environment.nix
    ./git.nix
    ./gtk.nix
    ./packages.nix
    ./shells.nix
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/nixgl-compat/modules/misc/nixgl.nix";
      sha256 = "01dkfr9wq3ib5hlyq9zq662mp0jl42fw3f6gd2qgdf8l8ia78j7i";
    })
  ];

  # nixpkgs = {
  # overlays = [
  # outputs.overlays.selective-update
  # ];
  # };

  programs.home-manager.enable = true;

  home = {
    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      options = "caps:escape_shifted_capslock, compose:rctrl";
    };
  };

  nixGL.prefix = "${inputs.nixGL.packages."${pkgs.system}".nixGLIntel}/bin/nixGLIntel";
  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
}
