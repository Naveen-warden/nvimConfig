return {
  'catppuccin/nvim',
  lazy = false,
  config = function()
    vim.cmd 'colorscheme catppuccin'

    -- Make everything in normal font except for comments, keywords, and function arguments
    --highlight Keyword cterm=italic gui=italic
    -- highlight Function cterm=italic gui=italic

    vim.cmd [[
            highlight Comment cterm=italic gui=italic
        ]]
  end,
}
