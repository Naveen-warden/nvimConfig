-- return {
--   'mason-org/mason.nvim',
--   commit = '7e0d8c4',
--   config = function()
--     require('mason').setup()
--   end,
-- }
return {

  'mason-org/mason.nvim',
  commit = '7e0d8c4',
  dependencies = {
    'williamboman/mason-lspconfig.nvim', -- LSP server installation management
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Install external tools (like formatters)
  },
  config = function()
    -- Mason setup for LSP servers and external tools
    require('mason').setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }

    -- Mason-LSPConfig setup with automatic installation of required LSP servers
    require('mason-lspconfig').setup {
      automatic_installation = true,
      ensure_installed = {
        -- JavaScript/TypeScript
        'ts_ls', -- TypeScript/JavaScript server
        'eslint', -- ESLint
        'quick_lint_js', -- Fast JavaScript linter

        -- Web Development
        'cssls', -- CSS
        'html', -- HTML
        'jsonls', -- JSON
        'tailwindcss', -- Tailwind CSS
        'emmet_ls', -- Emmet support
        'cssmodules_ls', -- CSS Modules
      },
    }

    -- Mason Tool Installer setup (for external tools like formatters)
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- Formatters
        'prettier', -- For JS/TS/HTML/CSS/JSON
        'eslint_d', -- Fast ESLint
        'stylua', -- Lua formatter

        -- Linters
        'eslint_d',
        'jsonlint',
        'markdownlint',

        -- Debug Adapters
        'js-debug-adapter', -- JavaScript/TypeScript debugging

        -- Additional Tools
        'typescript-language-server',
        'json-lsp',
      },
      auto_update = true,
      run_on_start = true,
    }
  end,
}
