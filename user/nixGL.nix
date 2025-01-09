{
  pkgs,
  config,
  nixgl,
  ...
}: {
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  # nixGL.offloadWrapper = "nvidiaPrime";
  nixGL.installScripts = ["mesa"];

  programs.alacritty.package = config.lib.nixGL.wrap pkgs.alacritty;
  programs.ghostty.package = config.lib.nixGL.wrap pkgs.ghostty;

  home.packages = [
    (config.lib.nixGL.wrap pkgs.keymapp)
  ];
}
