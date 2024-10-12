{
  config,
  lib,
  pkgs,
  setup,
  ...
}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      # LazyVim
      # lua-language-server
      # stylua
      # Telescope
      # ripgrep
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraLuaConfig = let
      plugins = with pkgs.vimPlugins; [
        oil-nvim
        # LazyVim
        # LazyVim
        # bufferline-nvim
        # cmp-buffer
        # cmp-nvim-lsp
        # cmp-path
        # cmp_luasnip
        # conform-nvim
        # dashboard-nvim
        # dressing-nvim
        # flash-nvim
        # friendly-snippets
        # gitsigns-nvim
        # indent-blankline-nvim
        # lualine-nvim
        # neo-tree-nvim
        # neoconf-nvim
        # neodev-nvim
        # noice-nvim
        # nui-nvim
        # nvim-cmp
        # nvim-lint
        # nvim-lspconfig
        # nvim-notify
        # nvim-spectre
        # nvim-treesitter
        # nvim-treesitter-context
        # nvim-treesitter-textobjects
        # nvim-ts-autotag
        # nvim-ts-context-commentstring
        # nvim-web-devicons
        # persistence-nvim
        # plenary-nvim
        # telescope-fzf-native-nvim
        # telescope-nvim
        # todo-comments-nvim
        # tokyonight-nvim
        # trouble-nvim
        # vim-illuminate
        # vim-startuptime
        which-key-nvim
        # { name = "LuaSnip"; path = luasnip; }
        # { name = "catppuccin"; path = catppuccin-nvim; }
        # { name = "mini.ai"; path = mini-nvim; }
        # { name = "mini.bufremove"; path = mini-nvim; }
        # { name = "mini.comment"; path = mini-nvim; }
        # { name = "mini.indentscope"; path = mini-nvim; }
        # { name = "mini.pairs"; path = mini-nvim; }
        # { name = "mini.surround"; path = mini-nvim; }
      ];
      mkEntryFromDrv = drv:
        if lib.isDerivation drv
        then {
          name = "${lib.getName drv}";
          path = drv;
        }
        else drv;
      lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
    in ''
      vim.g.mapleader = " " -- Need to set leader before lazy for correct keybindings
      vim.g.maplocalleader = " "

      vim.g.have_nerd_font = true

      require("lazy").setup({
        defaults = {
          lazy = true,
        },
        dev = {
          -- reuse files from pkgs.vimPlugins.*
          path = "${lazyPath}",
          patterns = {""}, --Specify that all of our plugins will use the dev dir. Empty string is a wildcard!
          -- patterns = { "." },
          -- fallback to download
          -- fallback = true,
        },
        performance = {
          reset_packpath = false,
          rtp = {
            reset = false,
          }
        },
        spec = {
          -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- The following configs are needed for fixing lazyvim on nix
          -- force enable telescope-fzf-native.nvim
          -- { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
          -- disable mason.nvim, use programs.neovim.extraPackages
          -- { "williamboman/mason-lspconfig.nvim", enabled = false },
          -- { "williamboman/mason.nvim", enabled = false },
          -- import/override with your plugins
          { import = "plugins" },
          -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
          -- { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = {} } },
        },
        install = {
          -- Safeguard in case we forget to install a plugin with Nix
          -- missing = false,
          missing = true,
        },
      })

      require("config")
    '';
  };

  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./lua;
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  # xdg.configFile."nvim/parser".source = let
  # parsers = pkgs.symlinkJoin {
  # name = "treesitter-parsers";
  # paths =
  # (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
  # with plugins; [
  # c
  # lua
  # ]))
  # .dependencies;
  # };
  # in "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  # xdg.configFile."nvim/lua".source = ./lua;

  home.packages = let
    nvim_pkgs = import (builtins.fetchTarball {
      name = "pkgs-neovim-0.9.5";
      url = "https://github.com/NixOS/nixpkgs/archive/0c19708cf035f50d28eb4b2b8e7a79d4dc52f6bb.tar.gz";
      sha256 = "0ngw2shvl24swam5pzhcs9hvbwrgzsbcdlhpvzqc7nfk8lc28sp3";
    }) {inherit (pkgs) system;};
  in
    if setup.isNixOS
    then []
    else [nvim_pkgs.neovim];
}
