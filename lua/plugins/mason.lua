return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim', -- LSP server installation management
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Install external tools (like formatters)
  },
  config = function()
    -- Mason setup for LSP servers and external tools
    require('mason').setup()

    -- Mason-LSPConfig setup with automatic installation of required LSP servers
    require('mason-lspconfig').setup {
      automatic_installation = true, -- Automatically install missing servers
      ensure_installed = {
        -- LSP servers for TypeScript, JavaScript, React, and CSS
        'eslint', -- ESLint for JavaScript and TypeScript linting
        'cssls', -- CSS LSP (for CSS, SCSS, and other styles)
        'html', -- HTML LSP
        'tailwindcss', -- Tailwind CSS IntelliSense
        'jsonls', -- JSON LSP
      },
    }

    -- Mason Tool Installer setup (for external tools like formatters)
    require('mason-tool-installer').setup {
      ensure_installed = {
        -- Formatters and linters for frontend development
        'prettier', -- Prettier for formatting JS, TS, HTML, and CSS
        'stylua', -- Lua formatter
        'eslint_d', -- eslint_d for faster linting
      },
      auto_update = true, -- Automatically update installed tools
    }
  end,
}
