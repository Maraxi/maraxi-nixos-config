{
  inputs,
  pkgs,
  config,
  ...
}: {
  nixGL.prefix = "${inputs.nixGL.packages."${pkgs.system}".nixGLIntel}/bin/nixGLIntel";
  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
}
