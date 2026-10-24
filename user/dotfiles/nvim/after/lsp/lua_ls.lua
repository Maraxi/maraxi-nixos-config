-- Special Lua Config, as recommended by neovim help docs

-- ~/.config/nvim is a symlink into the home-manager repo, so compare real paths
local function real(path) return path and vim.uv.fs_realpath(path) or path end

return {
  -- Use the nvim config itself as the workspace when editing it, instead of
  -- whichever parent directory (here: the dotfiles repo) holds a root marker
  root_dir = function(bufnr, on_dir)
    local config = real(vim.fn.stdpath 'config')
    local name = real(vim.api.nvim_buf_get_name(bufnr))
    if config and name and vim.startswith(name, config .. '/') then
      on_dir(config)
    else
      on_dir(vim.fs.root(bufnr, vim.lsp.config.lua_ls.root_markers))
    end
  end,

  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then return end
    end

    -- The library (Neovim runtime and plugins) is managed by lazydev.nvim, see plugins/lsp.lua
    local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
    client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = { 'lua/?.lua', 'lua/?/init.lua' },
      },
      workspace = {
        checkThirdParty = false,
      },
    })
  end,
  ---@type lspconfig.settings.lua_ls
  settings = {
    Lua = {
      format = { enable = false }, -- Disable formatting (formatting is done by stylua)
    },
  },
}
