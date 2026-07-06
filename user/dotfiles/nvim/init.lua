-- #######################
-- ##      OPTIONS      ##
-- #######################

-- TODO: test: vim.loader.enable()
-- vim.cmd([[set mouse=]])  -- TODO: need to fix jump, usually ^] / :tag
-- vim.opt.mouse = '' / 'a'

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.undofile = true
-- Decrease update time
vim.opt.updatetime = 250
-- Decrease mapped sequence wait time
-- Displays which-key pop-up sooner
vim.opt.timeoutlen = 300

vim.opt.clipboard = 'unnamedplus'
vim.opt.title = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.tabstop = 8
vim.opt.shiftwidth = 8

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
-- vim.opt.showtabline = 2

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

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

-- #######################
-- ##      PLUGINS      ##
-- #######################

-- ensure plugin specific updates run after vim.pack.update()
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
  -- { src = 'https://GitHub.com/nvim-telescope/telescope.nvim' },
}

vim.cmd.colorscheme 'tokyonight'

require('mini.statusline').setup {}

-- TODO: https://tduyng.com/blog/neovim-git-tools/

-- #########################
-- ##      KEY BINDS      ##
-- #########################

-- Run lines in lua
vim.keymap.set('n', '<leader><leader>X', '<cmd>restart<CR>')
vim.keymap.set('n', '<leader><leader>x', '<cmd>source $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':lua<CR>')

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

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
