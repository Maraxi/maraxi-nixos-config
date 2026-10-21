-- ##############################
-- ##      UI/UX Plug ins      ##
-- ##############################
require 'plugins.helpers'
do
  -- [[ colorscheme ]]
  vim.pack.add { GH 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyoniGHt').setup {
    styles = {
      comments = { italic = false },
    },
  }
  vim.cmd.colorscheme 'tokyoniGHt-moon'

  vim.pack.add { GH 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- [[ which key ]]
  -- Useful plugin to show you pending keybinds.
  vim.pack.add { GH 'folke/which-key.nvim' }
  require('which-key').setup {
    -- Delay between pressing a key and opening which-key (milliseconds)
    delay = 0,
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  -- [[ git signs ]]
  vim.pack.add { GH 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = { add = { text = '+' }, change = { text = '~' } },
    signs_staged = { add = { text = '+' }, change = { text = '~' } },
    -- TODO: kickstart commands to move to next change and interact with hunks
  }

  -- [[ todo comments ]]
  vim.pack.add { GH 'folke/todo-comments.nvim' }
  -- TODO: optional reqs:
  --      plenary.nvim
  --      trouble
  --      telescope
  --      fzflua
  require('todo-comments').setup { signs = false }

  do -- [[ mini.nvim ]]
    vim.pack.add { GH 'nvim-mini/mini.nvim' }

    require('mini.icons').setup()
    -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
    MiniIcons.mock_nvim_web_devicons()

    require('mini.ai').setup {
      -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
      mappings = {
        around_next = 'aa',
        inside_next = 'ii',
      },
      n_lines = 500,
    }

    -- TODO: figure out how that works
    require('mini.surround').setup()

    local statusline = require 'mini.statusline'
    statusline.setup {}
    -- set the section for cursor location to LINE:COLUMN
    -- statusline.section_location = function() return '%2l:%-2v' end

    -- TODO: more mini tools
    -- https://github.com/nvim-mini/mini.nvim
  end
end
