vim.g.mapleader = ' '

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

----------------------------------
-- Essential Operations -----------
----------------------------------
-- Save and Quit
map('n', '<leader>w', '<CMD>update<CR>', { desc = 'Save file' })
map('n', '<leader>q', '<CMD>q<CR>', { desc = 'Quit' })
map('n', 'QQ', ':q!<enter>', { desc = 'Force quit' })
map('n', 'W', ':w!<enter>', { desc = 'Force save' })

-- Better window navigation
map('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })

-- Resize with arrows
map('n', '<C-Up>', ':resize -2<CR>', { desc = 'Resize window up' })
map('n', '<C-Down>', ':resize +2<CR>', { desc = 'Resize window down' })
map('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Resize window left' })
map('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Resize window right' })

----------------------------------
-- Text Editing -----------------
----------------------------------
-- Exit insert mode
map('i', 'jj', '<ESC>', { desc = 'Exit insert mode' })

-- Better indenting
map('v', '<', '<gv', { desc = 'Indent left and reselect' })
map('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Move text up and down
map('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move text down' })
map('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move text up' })

-- Better paste
map('v', 'p', '"_dP', { desc = 'Paste without yanking' })

-- Clear search with <esc>
map('n', '<esc>', ':noh<CR>', { desc = 'Clear search highlights' })

----------------------------------
-- File Navigation --------------
----------------------------------
-- Buffer navigation
map('n', 'H', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
map('n', 'L', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
map('n', 'Q', ':bd!<CR>', { desc = 'Close buffer' })

-- Quick window splits
map('n', '<leader>\\', '<CMD>vsplit<CR>', { desc = 'Split window vertically' })
map('n', '<leader>-', '<CMD>split<CR>', { desc = 'Split window horizontally' })

-- File explorer
map('n', '<leader>e', '<CMD>Neotree toggle<CR>', { desc = 'Toggle file explorer' })

----------------------------------
-- Code Navigation --------------
----------------------------------
-- Move to line ends
map('n', 'E', '$', { desc = 'Go to end of line' })
map('n', 'B', '^', { desc = 'Go to start of line' })

-- LSP
map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
map('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover information' })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code actions' })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })

----------------------------------
-- UI Toggles ------------------
----------------------------------
-- Toggle wrap
map('n', '<leader>tw', function()
    local wrap = not vim.opt.wrap:get()
    vim.opt.wrap = wrap
    vim.opt.linebreak = wrap
    vim.opt.breakindent = wrap
    vim.opt.breakindentopt = 'shift:2'
    print('Wrap: ' .. (wrap and 'ON' or 'OFF'))
end, { desc = 'Toggle word wrap' })

-- Toggle transparency
map('n', 'TT', ':TransparentToggle<CR>', { desc = 'Toggle transparency' })

----------------------------------
-- Search and Replace -----------
----------------------------------
-- Search in current file
map('n', '<leader>/', ':Telescope current_buffer_fuzzy_find<CR>', { desc = 'Search in current file' })

-- Search in all files
map('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Search in all files' })

-- Replace in current file
map('n', '<leader>r', ':%s//g<Left><Left>', { desc = 'Replace in file' })
