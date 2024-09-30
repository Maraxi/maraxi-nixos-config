{
  config,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../../user/alacritty.nix
    ../../user/environment.nix
    ../../user/git.nix
    ../../user/gtk.nix
    ../../user/packages.nix
    ../../user/shells.nix
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
    username = "iv546";
    homeDirectory = "/home/iv546";
    keyboard = {
      layout = "de";
      variant = "nodeadkeys";
      options = "caps:escape_shifted_capslock, compose:rctrl";
    };
    stateVersion = "24.05";
  };

  nixGL.prefix = "${inputs.nixGL.packages."${pkgs.system}".nixGLIntel}/bin/nixGLIntel";
  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
}
