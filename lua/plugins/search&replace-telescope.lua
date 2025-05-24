return {
  'nvim-pack/nvim-spectre',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('spectre').setup {
      color_devicons = true,
      line_sep_start = '╭─────────────────────────────────────────',
      line_sep_end = '╰─────────────────────────────────────────',
      replace_engine = {
        ['sed'] = {
          cmd = 'sed',
          args = {
            '-i',
            '-E',
          },
          options = {
            ['ignore-case'] = false,
          },
        },
      },
      default = {
        find = {
          cmd = 'rg',
          options = { '--hidden', '--vimgrep' },
        },
        replace = {
          cmd = 'sed',
        },
      },
      live_update = true, -- auto-expose changes when you save file
      is_block_ui_break = true, -- prevent UI breaking in narrow windows
      is_open_target_win = true, -- open file in current window when possible
      highlight = {
        ui = 'String',
        search = 'DiffAdd',
        replace = 'DiffDelete',
        border = 'Comment',
      },
      mapping = {
        ['send_to_qf'] = {
          map = 'Q',
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = 'Send all items to quickfix',
        },
        ['replace_cmd'] = {
          map = 'R',
          cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
          desc = 'Input replace sed command',
        },
        ['show_option_menu'] = {
          map = '<leader>o',
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = 'Show search options',
        },
        ['toggle_ignore_case'] = {
          map = 'ic',
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = 'Toggle case ignore',
        },
        ['toggle_hidden'] = {
          map = 'ih',
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = 'Toggle hidden files',
        },
      },
    }

    -- Enhanced Keymaps
    local spectre = require 'spectre'
    vim.keymap.set('n', '<leader>sr', spectre.open, { desc = 'Open Spectre' })
    vim.keymap.set('n', '<leader>sf', function()
      spectre.open { path = vim.fn.expand '%:p' }
    end, { desc = 'Search in current file' })
    vim.keymap.set('n', '<leader>sw', function()
      spectre.open_visual { select_word = true }
    end, { desc = 'Search current word' })
    vim.keymap.set('v', '<leader>s', spectre.open_visual, { desc = 'Search selection' })

    -- Advanced Productivity Keymaps
    vim.keymap.set('n', '<leader>sl', function()
      spectre.open_visual { replace = { search = vim.fn.expand '<cword>' } }
    end, { desc = 'Live replace current word' })

    vim.keymap.set('n', '<leader>st', function()
      spectre.open {
        is_insert_mode = true,
        search_text = '',
        replace_text = '',
        path = '',
        cwd = vim.loop.cwd(),
        search = {
          filetype = vim.bo.filetype, -- Auto-limit to current buffer's filetype
        },
      }
    end, { desc = 'Search in current filetype' })

    vim.keymap.set('n', '<leader>sR', function()
      spectre.resume_last_search()
    end, { desc = 'Resume last search' })

    vim.keymap.set('n', 'sc', function()
      spectre.open_file_search { select_word = true }
    end, { desc = 'Search in current file (immediate)' })
  end,
}
