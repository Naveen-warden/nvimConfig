return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp', -- Completion support for LSP
    { 'folke/neodev.nvim', opts = {} }, -- For better Neovim configuration (especially for LSP)
  },
  config = function()
    -- Require necessary modules
    local nvim_lsp = require 'lspconfig'
    local mason_lspconfig = require 'mason-lspconfig'
    local cmp_nvim_lsp = require 'cmp_nvim_lsp'

    local protocol = require 'vim.lsp.protocol'

    -- Keymap helper function
    local function map(mode, lhs, rhs)
      vim.keymap.set(mode, lhs, rhs, { silent = true })
    end

    -- on_attach function to run when LSP attaches to a buffer
    local on_attach = function(client, bufnr)
      -- Format on save
      if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = vim.api.nvim_create_augroup('Format', { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format()
          end,
        })
      end

      -- Key mappings for LSP functionality
      map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
      map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
      map('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
      map('n', '<leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>')
      map('n', '<leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
    end

    -- Capabilities setup for nvim-cmp
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Mason LSP setup
    mason_lspconfig.setup_handlers {
      -- Default handler for most LSP servers
      function(server)
        nvim_lsp[server].setup {
          capabilities = capabilities,
          on_attach = on_attach,
        }
      end,

      -- Specific setup for each LSP server
      ['cssls'] = function()
        nvim_lsp['cssls'].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,
      ['tailwindcss'] = function()
        nvim_lsp['tailwindcss'].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,
      ['html'] = function()
        nvim_lsp['html'].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,
      ['jsonls'] = function()
        nvim_lsp['jsonls'].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,
      ['eslint'] = function()
        nvim_lsp['eslint'].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end,
    }
  end,
}
