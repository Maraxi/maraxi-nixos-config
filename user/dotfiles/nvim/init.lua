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
end

do -- diagnostics
  -- TODO: check this config
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
  }
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
end

-- ########################
-- ##      AutoCmds      ##
-- ########################
do
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    -- TODO: do I need the group?
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
  })

  -- Fix for german keyboard. Emulate <C-]> with <Enter> in help pages. See :help tag
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'help',
    callback = function() vim.keymap.set('n', '<CR>', '<C-]>', { buffer = true }) end,
  })

  vim.api.nvim_create_augroup('HelpVertical', { clear = true })
  vim.api.nvim_create_autocmd('BufWinEnter', {
    group = 'HelpVertical',
    callback = function(ev)
      if vim.bo[ev.buf].filetype == 'help' then vim.cmd 'wincmd L' end
    end,
  })
end

-- ###############################
-- ##      Plug in manager      ##
-- ###############################
do
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
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' and kind == 'update' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
      end
    end,
  })
end

local gh = function(x) return 'https://github.com/' .. x end

-- ##############################
-- ##      UI/UX Plug ins      ##
-- ##############################
do
  -- [[ colorscheme ]]
  vim.pack.add { gh 'folke/tokyonight.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('tokyonight').setup {
    styles = {
      comments = { italic = false },
    },
  }
  vim.cmd.colorscheme 'tokyonight-moon'

  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  -- [[ which key ]]
  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
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
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    signs = { add = { text = '+' }, change = { text = '~' } },
    signs_staged = { add = { text = '+' }, change = { text = '~' } },
    -- TODO: kickstart commands to move to next change and interact with hunks
  }

  -- [[ todo comments ]]
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  -- TODO: optional reqs:
  --      plenary.nvim
  --      trouble
  --      telescope
  --      fzflua
  require('todo-comments').setup { signs = false }

  do -- [[ mini.nvim ]]
    vim.pack.add { gh 'nvim-mini/mini.nvim' }

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

require 'plugins.telescope'
require 'plugins.lsp'
require 'plugins.conform'

-- ########################
-- ##      SNIPPETS      ##
-- ########################
do
  -- [[ Snippet Engine ]]
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}

  -- `friendly-snippets` contains a variety of premade snippets.
  --    See the README about individual language/framework/plugin snippets:
  --    https://github.com/rafamadriz/friendly-snippets
  --
  -- vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  -- require('luasnip.loaders.from_vscode').lazy_load()
end

-- ############################
-- ##      AUTOCOMPLETE      ##
-- ############################
do
  -- [[ Autocomplete Engine ]]
  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See `:help blink-cmp-config-keymap` for defining your own keymap
      preset = 'default',

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- By default, you may press `<c-space>` to show the documentation.
      -- Optionally, set `auto_show = true` to show the documentation after a delay.
      documentation = { auto_show = false, auto_show_delay_ms = 400 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See `:help blink-cmp-config-fuzzy` for more information
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  }
end

-- ##########################
-- ##      TREESITTER      ##
-- ##########################
-- Parser installation, syntax highlighting, folds, indentation
do
  -- [[ Configure Treesitter ]]
  --  See `:help nvim-treesitter-intro`
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Ensure basic parsers are installed
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if the buffer is valid (might not be after install completes)
    if not vim.api.nvim_buf_is_valid(buf) then return end

    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end

    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

-- #############################
-- ##      MORE PLUG INS      ##
-- #############################
do
  require 'plugins.other'
end
