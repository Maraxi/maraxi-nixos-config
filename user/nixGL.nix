{
  inputs,
  pkgs,
  config,
  nixgl,
  ...
}: {
  # nixGL.prefix = "${inputs.nixGL.packages."${pkgs.system}".nixGLIntel}/bin/nixGLIntel";
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  # nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = ["mesa"];

  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
}
