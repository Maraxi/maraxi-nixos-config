{
  setup,
  lib,
  pkgs,
  mutableLink,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
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
    inotify-tools # to replace default nvim file watcher
    lua-language-server
    stylua
    tombi # toml
    nil # nix

    (pkgs.runCommand "symlink-to-nvim" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.neovim}/bin/nvim $out/bin/v
    '')
  ];

  xdg.configFile = {
    "stylua.toml" = mutableLink dotfiles/stylua.toml;
    "tombi/config.toml" = mutableLink dotfiles/tombi.toml;
    "nvim" = lib.optionalAttrs setup.isNixOS (mutableLink dotfiles/nvim);
  };

  programs.bash.shellAliases = {
    sv = "sudoedit";
  };
}
