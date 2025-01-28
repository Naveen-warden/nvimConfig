-- Utility to load all plugin configurations from the plugins folder
local plugin_files = vim.fn.globpath(vim.fn.stdpath 'config' .. '/lua/plugins', '*.lua', false, true)

local plugins = {}
for _, file in ipairs(plugin_files) do
  if not file:find 'init.lua' then
    local plugin = dofile(file)
    table.insert(plugins, plugin)
  end
end

return plugins
