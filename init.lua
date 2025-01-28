-- Prepend lazy.nvim to runtime path
vim.opt.rtp:prepend '~/.local/share/nvim/lazy/lazy.nvim'

-- Load plugins from plugins/init.lua

require 'settings'
require 'keymaps'
require 'autocmds'

local plugins = require 'plugins'
require('lazy').setup(plugins)
