return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    operators = { gc = 'Comments' },
    key_labels = {
      ['<space>'] = 'SPC',
      ['<cr>'] = 'RET',
      ['<tab>'] = 'TAB',
    },
    window = {
      border = 'single',
      position = 'bottom',
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = 'left',
    },
  },
  config = function(_, opts)
    local wk = require 'which-key'
    wk.setup(opts)

    -- Register key mappings
    wk.register {
      ['<leader>f'] = { name = '+file' },
      ['<leader>g'] = { name = '+git' },
      ['<leader>l'] = { name = '+lsp' },
      ['<leader>s'] = { name = '+search' },
      ['<leader>w'] = { name = '+window' },
      ['<leader>b'] = { name = '+buffer' },
    }
  end,
}

