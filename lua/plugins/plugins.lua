return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    opts = function()
      local logo = [[
                                                                             
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████ 
      ]]

      logo = string.rep('\n', 8) .. logo .. '\n\n'

      local opts = {
        theme = 'doom',
        hide = {
          -- this is taken care of by lualine
          -- enabling this messes up the actual laststatus setting after loading a file
          statusline = false,
        },
        config = {
          header = vim.split(logo, '\n'),
                -- stylua: ignore
                center = {
                    { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
                    { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
                    { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
                    { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
                    {
                        action = [[lua require("lazyvim.util").telescope.config_files()()]],
                        desc = " Config",
                        icon = " ",
                        key = "c"
                    },
                    { action = 'lua require("persistence").load()', desc = " Restore Session", icon = " ", key = "s" },
                    { action = "LazyExtras", desc = " Lazy Extras", icon = " ", key = "x" },
                    { action = "Lazy", desc = " Lazy", icon = "󰒲 ", key = "l" },
                    { action = "qa", desc = " Quit", icon = " ", key = "q" },
                },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ Neovim loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms' }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = button.desc .. string.rep(' ', 43 - #button.desc)
        button.key_format = '  %s'
      end

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == 'lazy' then
        vim.cmd.close()
        vim.api.nvim_create_autocmd('User', {
          pattern = 'DashboardLoaded',
          callback = function()
            require('lazy').show()
          end,
        })
      end

      return opts
    end,
  },

  -- comments
  {
    'numToStr/Comment.nvim',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
    config = function()
      -- Prevent loading deprecated module

      -- Setup context commentstring properly
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }

      -- Setup Comment.nvim with the context-aware hook
      require('Comment').setup {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      }
    end,
  },
  -- nice config
  -- smooth scrolling
  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup {
        -- Customize settings as needed
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = nil,
        pre_hook = nil,
        post_hook = nil,
        performance_mode = false,
      }
    end,
  },
  --keep cursor centered while scrolling
  {
    'arnamak/stay-centered.nvim',
    config = function()
      require('stay-centered').setup()
    end,
  },
  -- to list marks in a file
  {
    '2kabhishek/markit.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('markit').setup {
        -- Enable default key mappings
        default_mappings = true,
        -- Display these built-in marks
        builtin_marks = { '.', '<', '>', '^' },
        -- Enable cyclic navigation through marks
        cyclic = true,
        -- Update shada file after modifying uppercase marks
        force_write_shada = false,
        -- Frequency (in ms) to redraw signs and recompute mark positions
        refresh_interval = 1000,
      }
    end,
  },
  --fold
  -- {
  --   'kevinhwang91/nvim-ufo',
  --   dependencies = 'kevinhwang91/promise-async',
  --   config = function()
  --     vim.o.foldcolumn = '1' -- '0' is not bad
  --     vim.o.foldenable = false
  --     local capabilities = vim.lsp.protocol.make_client_capabilities()
  --     capabilities.textDocument.foldingRange = {
  --       dynamicRegistration = false,
  --       lineFoldingOnly = true,
  --     }
  --     local language_servers = vim.lsp.get_clients() -- or list servers manually like {'gopls', 'clangd'}
  --     for _, ls in ipairs(language_servers) do
  --       require('lspconfig')[ls].setup {
  --         capabilities = capabilities,
  --         -- you can add other fields for setting up lsp server in this table
  --       }
  --     end
  --     require('ufo').setup()
  --   end,
  -- },
  -- auto tag
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- auto close for brackets,queotes..etc
  {
    'm4xshen/autoclose.nvim',
    event = { 'InsertEnter' },
    config = function()
      require('autoclose').setup()
    end,
  },
  -- flash (used for navigation)
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
}
