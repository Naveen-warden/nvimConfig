return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Autocompletion
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      -- Snippets
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- Additional dependencies
      'folke/neodev.nvim',
      'b0o/schemastore.nvim', -- JSON schema support
    },
    config = function()
      local lspconfig = require 'lspconfig'
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Enable folke/neodev for better Lua development
      require('neodev').setup()

      -- Enhanced capabilities
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.preselectSupport = true
      capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
      capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
      capabilities.textDocument.completion.completionItem.deprecatedSupport = true
      capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        },
      }

      -- Improved keymaps with better descriptions
      local function map(mode, lhs, rhs, bufnr, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
      end

      -- Enhanced on_attach function
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Mappings
        map('n', 'gD', vnm.lsp.buf.declaration, bufnr, 'Go to declaration')
        map('n', 'gd', vim.lsp.buf.definition, bufnr, 'Go to definition')
        map('n', 'K', vim.lsp.buf.hover, bufnr, 'Hover documentation')
        map('n', 'gi', vim.lsp.buf.implementation, bufnr, 'Go to implementation')
        map('n', '<C-k>', vim.lsp.buf.signature_help, bufnr, 'Signature help')
        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufnr, 'Add workspace folder')
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufnr, 'Remove workspace folder')
        map('n', '<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufnr, 'List workspace folders')
        map('n', '<leader>D', vim.lsp.buf.type_definition, bufnr, 'Type definition')
        map('n', '<leader>rn', vim.lsp.buf.rename, bufnr, 'Rename')
        map('n', '<leader>ca', vim.lsp.buf.code_action, bufnr, 'Code actions')
        map('n', 'gr', vim.lsp.buf.references, bufnr, 'Go to references')
        map('n', '<leader>f', function()
          vim.lsp.buf.format { async = true }
        end, bufnr, 'Format')

        -- Enhanced code action support
        if client.server_capabilities.codeActionProvider then
          map('n', '<leader>ca', vim.lsp.buf.code_action, bufnr, 'Code actions')
          map('v', '<leader>ca', vim.lsp.buf.code_action, bufnr, 'Code actions (range)')
        end

        -- Auto-import on save if supported
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('LspFormat.' .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false, bufnr = bufnr }
              -- Attempt to organize imports if available
              if client.name == 'tsserver' then
                vim.lsp.buf.execute_command {
                  command = '_typescript.organizeImports',
                  arguments = { vim.api.nvim_buf_get_name(bufnr) },
                }
              end
            end,
          })
        end
      end

      -- TypeScript/JavaScript configuration
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            suggest = {
              completeFunctionCalls = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
            suggest = {
              completeFunctionCalls = true,
            },
          },
        },
      }

      -- ESLint configuration
      lspconfig.eslint.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          workingDirectory = { mode = 'auto' },
          format = true,
          quiet = false,
          onIgnoredFiles = 'off',
          rulesCustomizations = {},
          run = 'onType',
          problems = {
            shortenToSingleLine = false,
          },
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = 'separateLine',
            },
            showDocumentation = {
              enable = true,
            },
          },
        },
      }

      -- HTML configuration
      lspconfig.html.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = 'auto',
            },
            hover = {
              documentation = true,
              references = true,
            },
          },
        },
      }

      -- CSS configuration
      lspconfig.cssls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          css = {
            validate = true,
            lint = {
              compatibleVendorPrefixes = 'warning',
              vendorPrefix = 'warning',
              duplicateProperties = 'warning',
            },
          },
        },
      }

      -- JSON configuration with schema support
      lspconfig.jsonls.setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }
    end,
  },
}
