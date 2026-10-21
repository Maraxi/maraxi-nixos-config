-- ##########################
-- ##      FORMATTING      ##
-- ##########################
require 'plugins.helpers'
do
  -- [[ Formatting ]]
  vim.pack.add { GH 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local enabled_filetypes = {
        lua = true,
        nix = true,
        python = true,
        sh = true,
        toml = true,
      }

      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_fix', 'ruff_format' },
      nix = { 'nixfmt' },
      sh = { 'shfmt', 'shellharden' },
    },
    formatters = {
      shfmt = {
        append_args = { '--simplify', '--case-indent', '--indent=2' },
      },
    },
  }

  vim.keymap.set(
    { 'n', 'v' },
    '<leader>f',
    function() require('conform').format { async = true } end,
    { desc = '[F]ormat buffer' }
  )
end
