{
  setup,
  lib,
  config,
  pkgs,
  ...
}: {
  programs.neovim = {
    enable = true;
    sideloadInitLua = true;
    vimAlias = true;
    # vimdiffAlias = true;
    withRuby = false;
    withPython3 = false;
  };

  home.packages = with pkgs; [
    # treesitter
    nodejs
    tree-sitter

    # lsp
    lua-language-server
  ];

  xdg.configFile = lib.optionalAttrs setup.isNixOS {"nvim".source = config.lib.meta.mkMutableSymlink dotfiles/nvim;};

  programs.bash.shellAliases = {
    v = "nvim";
    nv = "nvim";
    sv = "sudoedit";
  };
}
