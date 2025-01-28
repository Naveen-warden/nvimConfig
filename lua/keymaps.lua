vim.g.mapleader = ' '

local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true })
end

-- Save
map('n', '<leader>w', '<CMD>update<CR>')

-- Quit
map('n', '<leader>q', '<CMD>q<CR>')

-- Exit insert mode
map('i', 'jj', '<ESC>')

-- NeoTree
map('n', '<leader>e', '<CMD>Neotree toggle<CR>')

-- New Windows
map('n', '<leader>o', '<CMD>vsplit<CR>')
map('n', '<leader>p', '<CMD>split<CR>')

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the right window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the top window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the bottom window' })

-- Resize Windows
map('n', '<C-Left>', '<C-w><')
map('n', '<C-Right>', '<C-w>>')
map('n', '<C-Up>', '<C-w>+')
map('n', '<C-Down>', '<C-w>-')

-- files
map('n', 'QQ', ':q!<enter>', { noremap = false })
map('n', 'W', ':w!<enter>', { noremap = false })
map('n', 'E', '$', { noremap = false })
map('n', 'B', '^', { noremap = false })
map('n', 'TT', ':TransparentToggle<CR>', { noremap = true })
map('n', 'ss', ':noh<CR>', { noremap = true })

--Buffers
map('n', 'H', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
map('n', 'L', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
map('n', 'Q', ':bd!<CR>', { noremap = true, silent = true })

map('n', '<leader>w', function()
  local wrap = not vim.opt.wrap:get()
  vim.opt.wrap = wrap
  vim.opt.linebreak = wrap
  vim.opt.breakindent = wrap
  -- vim.opt.showbreak = "↪ "
  vim.opt.breakindentopt = 'shift:2'
  print('Wrap: ' .. (wrap and 'ON' or 'OFF'))
end, { desc = 'Toggle visual wrapping' })
