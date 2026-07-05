-- #######################
-- ##      OPTIONS      ##
-- #######################
-- vim.cmd([[set mouse=]])  -- need to fix jump, usually ^] / :tag

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.undofile = true
vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop = 8
vim.opt.shiftwidth = 8

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.showtabline = 2

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.scrolloff = 20
vim.opt.sidescrolloff = 10

-- ########################
-- ##      KEYBINDS      ##
-- ########################
-- Run lines in lua
vim.keymap.set('n', '<leader><leader>x', '<cmd>source $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':lua<CR>')

-- #######################
-- ##      SCRIPTS      ##
-- #######################
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

print 'init.lua was loaded'

-- #######################
-- ##      PLUGINS      ##
-- #######################
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
