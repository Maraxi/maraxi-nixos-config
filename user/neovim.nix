{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    # vimdiffAlias = true;
  };

  home.packages = with pkgs; [
    # treesitter
    nodejs
    tree-sitter

    # lsp
    lua-language-server
  ];

  # xdg.configFile."nvim" = {
  #   recursive = true;
  #   source = ./neovim;
  # };
}
