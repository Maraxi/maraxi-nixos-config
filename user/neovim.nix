{...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    # vimdiffAlias = true;
  };

  # xdg.configFile."nvim" = {
  #   recursive = true;
  #   source = ./neovim;
  # };
}
