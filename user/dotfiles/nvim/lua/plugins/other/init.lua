-- Iterate over all Lua files in the plugins directory and load them.
-- `vim.fs.dir()` iteration order is unspecified and must not be relied upon.
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'plugins', 'other')
for file_name, type in vim.fs.dir(plugins_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    local module = file_name:gsub('%.lua$', '')
    require('plugins.other.' .. module)
  end
end
