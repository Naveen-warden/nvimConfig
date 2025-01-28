return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    {
      'L3MON4D3/LuaSnip',
      version = 'v2.*',
      -- install jsregexp (optional!)
      build = 'make install_jsregexp',
    },
    'rafamadriz/friendly-snippets',
    'onsails/lspkind.nvim', -- vs-code like pictograms
  },
  config = function()
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    local luasnip = require 'luasnip'

    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true } -- Confirm the currently selected item
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump() -- Expand or jump through snippets
          else
            fallback() -- Fallback to normal <Tab> behavior
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item() -- Navigate backward in the completion menu
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1) -- Jump backward in snippets
          else
            fallback() -- Fallback to normal <S-Tab> behavior
          end
        end, { 'i', 's' }),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      formatting = {
        format = lspkind.cmp_format {
          maxwidth = 50,
          ellipsis_char = '...',
        },
      },
    }

    vim.cmd [[
      set completeopt=menuone,noinsert,noselect
      highlight! default link CmpItemKind CmpItemMenuDefault
    ]]
  end,
}
