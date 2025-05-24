-- Ensure files open in buffers, not tab pages
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    if vim.bo.filetype ~= 'help' and vim.bo.filetype ~= 'qf' then
      vim.cmd 'set showtabline=2' -- Always show the tabline
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePre' }, {
  callback = function()
    vim.opt.shiftwidth = 4
    vim.opt.tabstop = 4
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    vim.opt.wrap = true
    vim.opt.linebreak = true
    vim.opt.breakindent = true
    vim.opt.breakindentopt = 'shift:2'
    -- vim.opt.showbreak = '↪ '
    print 'Wrap: ON'
  end,
})
