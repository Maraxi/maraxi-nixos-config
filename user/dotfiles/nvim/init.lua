-- #######################
-- ##      OPTIONS      ##
-- #######################

-- TODO: test: vim.loader.enable()
-- vim.cmd([[set mouse=]])  -- TODO: need to fix jump, usually ^] / :tag

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.undofile = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.title = true

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

-- #######################
-- ##      PLUGINS      ##
-- #######################

vim.api.nvim_create_autocmd('PackChanged', { callback = function(ev)
  local name, kind = ev.data.spec.name, ev.data.kind
  if name == 'nvim-treesitter' and kind == 'update' then
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end
end })

vim.pack.add {
  { src = 'https://github.com/folke/tokyonight.nvim' },
  { src = 'https://github.com/nvim-mini/mini.nvim' },
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
  -- { src = 'https://github.com/nvim-telescope/telescope.nvim' },
}

vim.cmd.colorscheme 'tokyonight'

-- TODO: https://tduyng.com/blog/neovim-git-tools/

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

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  -- TODO: do I need the group?
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
