return {
  'akinsho/bufferline.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers', -- Show buffers instead of actual tab pages
        numbers = 'ordinal', -- Show buffer numbers
        diagnostics = 'nvim_lsp', -- Show LSP diagnostics in bufferline
        separator_style = 'slant', -- Visual separator between buffers
        always_show_bufferline = true, -- Keep the bufferline visible
        show_buffer_close_icons = true, -- Show close icons
        offsets = {
          {
            filetype = 'NvimTree',
            text = 'File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
      },
    }
  end,
}
