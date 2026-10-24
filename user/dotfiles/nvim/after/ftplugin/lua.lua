local set = vim.opt_local

set.tabstop = 2
set.shiftwidth = 2
set.expandtab = true

-- gf on `require 'common'` or `common.setup`: resolve modules next to the current file, dropping trailing fields
function _G.lua_includeexpr(fname)
  local dir = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(0)))
  local parts = vim.split(fname, '.', { plain = true })
  while #parts > 0 do
    local base = vim.fs.joinpath(dir, table.concat(parts, '/'))
    for _, candidate in ipairs { base .. '.lua', base .. '/init.lua' } do
      if vim.uv.fs_stat(candidate) then return candidate end
    end
    table.remove(parts)
  end
  return require('vim._ftplugin.lua').includeexpr(fname)
end

set.includeexpr = 'v:lua.lua_includeexpr(v:fname)'
