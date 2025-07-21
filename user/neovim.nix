{
  config,
  pkgs,
  ...
}: {
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

  xdg.configFile."nvim".source = config.lib.meta.mkMutableSymlink dotfiles/nvim;

  programs.bash.shellAliases = {
    nv = "nvim";
    snv = "sudoedit";
  };
}
