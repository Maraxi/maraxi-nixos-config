-- ####################
-- ##      LINT      ##
-- ####################
-- statix is no language server, so it runs through nvim-lint instead of vim.lsp.enable().
-- deadnix has no stdin mode, it lints the file on disk (so it updates after saving).
do
  vim.pack.add { GH 'mfussenegger/nvim-lint' }
  local lint = require 'lint'

  lint.linters_by_ft = {
    nix = { 'statix', 'deadnix' },
  }

  -- the statix config lives in tools/ of the flake, args may contain functions that return a string
  local statix = lint.linters.statix
  table.insert(statix.args, 2, function()
    local root = vim.fs.root(0, 'flake.nix')
    return '--config=' .. (root and vim.fs.joinpath(root, 'tools', 'statix.toml') or '.')
  end)

  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('lint', { clear = true }),
    callback = function()
      if vim.bo.modifiable then lint.try_lint() end
    end,
  })
end
