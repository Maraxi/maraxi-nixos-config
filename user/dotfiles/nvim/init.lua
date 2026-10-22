-- #######################
-- ##      Options      ##
-- #######################
do
  -- Enable experimental faster start up by caching compiled Lua modules
  vim.loader.enable()

  -- vim.cmd([[set mouse=]])  -- TODO: need to fix jump, usually ^] / :tag
  -- vim.o.mouse = '' / 'a'

  --    #### global keys ####
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  --    #### generic window and system interactions ####
  vim.o.title = true
  vim.o.undofile = true
  -- Decrease update time, debounce this long until writing to swap
  vim.o.updatetime = 250

  -- Sync clipboard between OS and Neovim.
  -- Schedule the setting after `UiEnter` because it can increase startup-time.
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  --    #### window decorations, etc. ####
  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  vim.o.splitright = true
  vim.o.splitbelow = true

  --    #### editor / display behaviour ####
  -- Decrease mapped sequence wait time
  -- Displays which-key pop-up sooner
  -- INFO: this might breaks gO / outline at low values
  vim.o.timeoutlen = 300
  -- prompt instead of failing with unsaved changes with commands like `:q`
  vim.o.confirm = true

  -- TODO: maybe check this again
  vim.o.tabstop = 8
  vim.o.shiftwidth = 8
  vim.o.softtabstop = -1

  -- Use vim.opt to configure with a table
  --   See `:help lua-options`
  --   and `:help lua-guide-options`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.signcolumn = 'yes'
  -- vim.opt.showtabline = 2

  vim.o.wrap = false
  vim.o.breakindent = true

  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.scrolloff = 25
  vim.o.sidescrolloff = 10

  vim.o.spell = true
  vim.o.spelllang = 'en_gb,de_de'

  vim.o.inccommand = 'split'
  vim.o.cursorline = true
end

-- ########################
-- ##      Key Maps      ##
-- ########################
do
  -- Run files or just active lines in lua
  vim.keymap.set('n', '<leader>R', '<cmd>restart<CR>', { desc = 'Restart nvim' })
  vim.keymap.set('n', '<leader>r', '<cmd>source $MYVIMRC<CR>', { desc = 'Reload configuration' })
  vim.keymap.set('n', '<leader>x', ':.lua<CR>', { desc = 'run current line' })
  vim.keymap.set('v', '<leader>x', ':lua<CR>', { desc = 'Run selected lines' })

  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlight on escape' })

  -- Keybinds to make split navigation easier.
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
  vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
  vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
  vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
  vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

  vim.keymap.set(
    'n',
    '<leader>dt',
    ':lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>',
    { desc = '[D]iagnostics [T]oggle' }
  )
end

require 'plugins.diagnostics'
require 'plugins.autocmds'
require 'plugins.pack'
require 'plugins.ui-ux'
require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.conform'
require 'plugins.autocomplete'
require 'plugins.treesitter'
require 'plugins.other'
