{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    # vimdiffAlias = true;
  };

  home.packages = with pkgs; [
    # treesitter
    node
    tree-sitter

    # dynamic lsps
    luajitPackages.lua-lsp
  ];

  # xdg.configFile."nvim" = {
  #   recursive = true;
  #   source = ./neovim;
  # };
}
