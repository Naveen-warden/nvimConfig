-- Utility to load all plugin configurations from the plugins folder
local plugin_files = vim.fn.globpath(vim.fn.stdpath 'config' .. '/lua/plugins', '*.lua', false, true)

-- Function to customize fold text
function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local num_lines = vim.v.foldend - vim.v.foldstart + 1
  return line .. ' ... ' .. num_lines .. ' lines'
end

-- Set the fold text to use the custom function
vim.opt.foldtext = 'v:lua.custom_fold_text()'
vim.g.skip_ts_context_commentstring_module = true
local plugins = {}
for _, file in ipairs(plugin_files) do
  if not file:find 'init.lua' then
    local plugin = dofile(file)
    table.insert(plugins, plugin)
  end
end
return plugins
