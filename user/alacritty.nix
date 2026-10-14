{ mutableLink, ... }: {
  programs.alacritty.enable = true;
  xdg.configFile."alacritty/alacritty.toml" = mutableLink dotfiles/alacritty.toml;
}
