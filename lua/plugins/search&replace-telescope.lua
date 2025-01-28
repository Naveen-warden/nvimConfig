return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('spectre').setup {
      color_devicons = true,
      line_sep_start = '----------------------------------',
      highlight = {
        ui = 'String',
        search = 'DiffAdd',
        replace = 'DiffChange',
      },
      mapping = {
        ['toggle_line'] = {
          map = 't',
          cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
          desc = 'Toggle current result',
        },
        ['replace_cmd'] = {
          map = 'r',
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = 'Input replace command',
        },
      },
    }
    -- Keymaps for convenience
    vim.keymap.set('n', '<leader>sr', "<cmd>lua require('spectre').open()<CR>", { desc = 'Open Spectre' })
    vim.keymap.set('n', '<leader>sw', "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", { desc = 'Search current word' })
    vim.keymap.set('v', '<leader>s', "<esc><cmd>lua require('spectre').open_visual()<CR>", { desc = 'Search in visual selection' })
  end,
}
