-- #######################
-- ##      Options      ##
-- #######################

-- TODO: test: vim.loader.enable()
-- vim.cmd([[set mouse=]])  -- TODO: need to fix jump, usually ^] / :tag
-- vim.opt.mouse = '' / 'a'

--    #### global keys ####
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--    #### generic window and system interactions ####
vim.opt.title = true
vim.opt.undofile = true
-- Decrease update time, debounce this long until writing to swap
vim.opt.updatetime = 250

vim.opt.clipboard = 'unnamedplus'
-- TODO: check if this makes a difference
-- vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

--    #### window decorations, etc. ####
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.splitright = true
vim.opt.splitbelow = true

--    #### editor / display behaviour ####
-- Decrease mapped sequence wait time
-- Displays which-key pop-up sooner
-- TODO: this breaks gO / outline at low values
vim.opt.timeoutlen = 1000
-- prompt instead of failing with unsaved changes with commands like `:q`
vim.opt.confirm = true

vim.opt.tabstop = 8
vim.opt.shiftwidth = 8
vim.opt.softtabstop = -1

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
-- vim.opt.showtabline = 2

vim.opt.wrap = false
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 10

vim.opt.spell = true
vim.opt.spelllang = 'en_gb,de_de'

vim.opt.inccommand = 'split'
vim.opt.cursorline = true

-- ########################
-- ##      Key Maps      ##
-- ########################

-- Run files or just active lines in lua
vim.keymap.set('n', '<leader><leader>X', '<cmd>restart<CR>')
vim.keymap.set('n', '<leader><leader>x', '<cmd>source $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':lua<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.diagnostic.config { virtual_text = true }

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-S-h>', '<C-w>H', { desc = 'Move window to the left' })
vim.keymap.set('n', '<C-S-l>', '<C-w>L', { desc = 'Move window to the right' })
vim.keymap.set('n', '<C-S-j>', '<C-w>J', { desc = 'Move window to the lower' })
vim.keymap.set('n', '<C-S-k>', '<C-w>K', { desc = 'Move window to the upper' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  -- TODO: do I need the group?
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- ########################
-- ##      Plug ins      ##
-- ########################
--  To inspect plugin state and pending updates, run
--    :lua vim.pack.update(nil, { offline = true })
--
--  To update plugins, run
--    :lua vim.pack.update()

-- ensure plugin specific updates run after vim.pack.update()
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.pack.add {
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  -- { src = 'https://GitHub.com/nvim-telescope/telescope.nvim' },
}

vim.cmd.colorscheme 'tokyonight'

require('mini.statusline').setup {}

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = { add = { text = '+' }, change = { text = '~' } },
  signs_staged = { add = { text = '+' }, change = { text = '~' } },
}

-- TODO: https://tduyng.com/blog/neovim-git-tools/

-- TODO: check if needed:
-- https://github.com/NMAC427/guess-indent.nvim
-- require('guess-indent').setup {}
