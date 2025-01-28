return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local conform = require 'conform'

    conform.setup {
      formatters = {
        prettier = {
          command = 'prettier',
          args = function(filetype)
            -- Explicit parser handling for file types
            local parser_map = {
              javascript = 'babel',
              typescript = 'typescript',
              css = 'css',
              html = 'html',
              json = 'json',
              yaml = 'yaml',
              markdown = 'markdown',
            }
            local parser = parser_map[filetype]
            return parser and { '--stdin-filepath', vim.fn.expand '%:p', '--parser', parser } or { '--stdin-filepath', vim.fn.expand '%:p' }
          end,
        },
        stylua = {
          command = 'stylua',
          args = { '--stdin-filepath', vim.fn.expand '%:p', '-' },
        },
      },

      formatters_by_ft = {
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescriptreact = { 'prettier' },
        css = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        lua = { 'stylua' },
      },
      format_on_save = false, -- Synchronous on-save formatting disabled
    }

    -- Async formatting after save
    local group = vim.api.nvim_create_augroup('ConformFormatOnSave', {})
    vim.api.nvim_create_autocmd('BufWritePost', {
      group = group,
      pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
      callback = function()
        conform.format {
          lsp_fallback = true,
          async = true,
          timeout_ms = 2000,
        }
      end,
    })

    -- Keymap for manual formatting
    vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
      conform.format {
        lsp_fallback = true,
        async = false,
        timeout_ms = 2000,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
