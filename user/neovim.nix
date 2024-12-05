{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    # vimdiffAlias = true;
  };

  # dynamic lsps
  home.packages = with pkgs; [
    luajitPackages.lua-lsp
  ];

  # xdg.configFile."nvim" = {
  #   recursive = true;
  #   source = ./neovim;
  # };
}
