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

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

-- ensure plugin specific updates run after vim.pack.update()
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
      run_build(name, { 'makesdf' }, ev.data.path)
      return
    end

    if name == 'LuaSnip' then
      if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
      return
    end

    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
    end
  end,
})

-- ##############################
-- ##      UI/UX Plug ins      ##
-- ##############################

-- [[ colorscheme ]]
vim.pack.add { 'https://github.com/folke/tokyonight.nvim' }
vim.cmd.colorscheme 'tokyonight-moon'

-- [[ which key ]]
-- Useful plugin to show you pending keybinds.
vim.pack.add { 'https://github.com/folke/which-key.nvim' }
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
vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = { add = { text = '+' }, change = { text = '~' } },
  signs_staged = { add = { text = '+' }, change = { text = '~' } },
}

-- [[ todo comments ]]
vim.pack.add { 'https://github.com/folke/todo-comments.nvim' }
-- TODO: optional reqs:
--      plenary.nvim
--      trouble
--      telescope
--      fzflua
require('todo-comments').setup { signs = false }

-- [[ mini.nvim ]]
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
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

-- TODO: check if needed:
-- https://github.com/NMAC427/guess-indent.nvim
-- require('guess-indent').setup {}

-- ############################################
-- ##      Search / Navigation Plug ins      ##
-- ############################################

vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
}

-- TODO: https://tduyng.com/blog/neovim-git-tools/
