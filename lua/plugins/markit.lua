return {
  '2kabhishek/markit.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('markit').setup {
      -- Disable default mappings to avoid conflicts
      default_mappings = false,
      -- Enable cyclic navigation through marks
      cyclic = true,
      -- Update shada file after modifying uppercase marks
      force_write_shada = false,
      -- Frequency (in ms) to redraw signs and recompute mark positions
      refresh_interval = 1000,
      -- Display these built-in marks
      builtin_marks = { '.', '<', '>', '^' },
    }

    -- Custom keybindings that don't conflict
    local keymap = vim.keymap.set
    -- Use <leader>m prefix for all mark operations
    keymap('n', '<leader>mm', '<cmd>MarKitSet<CR>', { desc = 'Set mark' })
    keymap('n', '<leader>md', '<cmd>MarKitDelete<CR>', { desc = 'Delete mark' })
    keymap('n', '<leader>mt', '<cmd>MarKitToggle<CR>', { desc = 'Toggle mark' })
    keymap('n', '<leader>mn', '<cmd>MarKitNext<CR>', { desc = 'Next mark' })
    keymap('n', '<leader>mp', '<cmd>MarKitPrev<CR>', { desc = 'Previous mark' })
    keymap('n', '<leader>ml', '<cmd>MarKitList<CR>', { desc = 'List marks' })
    
    -- Number marks (0-9)
    for i = 0, 9 do
      keymap('n', string.format('<leader>m%d', i), 
        string.format('<cmd>MarKitSetBookmark%d<CR>', i),
        { desc = string.format('Set bookmark %d', i) })
      keymap('n', string.format('<leader>md%d', i),
        string.format('<cmd>MarKitDeleteBookmark%d<CR>', i),
        { desc = string.format('Delete bookmark %d', i) })
    end

    -- Register with which-key if available
    local ok, wk = pcall(require, 'which-key')
    if ok then
      wk.register({
        ['<leader>m'] = { name = 'marks' },
      })
    end
  end,
} 