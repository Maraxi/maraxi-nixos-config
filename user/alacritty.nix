{
  lib,
  config,
  ...
}: {
  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.toml".source = config.lib.meta.mkMutableSymlink dotfiles/alacritty.toml;
}
