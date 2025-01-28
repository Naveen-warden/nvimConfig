
-- return {
--     'nvim-telescope/telescope.nvim',
--     dependencies = { 'nvim-lua/plenary.nvim' },
--     config = function()
--         local actions = require('telescope.actions')
--         local action_state = require('telescope.actions.state')
--         local telescope = require('telescope')
--
--         telescope.setup {
--             defaults = {
--                 layout_config = {
--                     horizontal = {
--                         preview_width = 0, -- Disable telescope's preview window
--                     },
--                 },
--                 mappings = {
--                     i = {
--                         ["<CR>"] = function(prompt_bufnr)
--                             local selected_entry = action_state.get_selected_entry()
--                             local file_path = selected_entry.path or selected_entry[1]
--
--                             -- Close telescope
--                             actions.close(prompt_bufnr)
--
--                             -- Open a floating popup with the image
--                             local cmd = string.format(
--                                 "tmux popup -E -w 60%% -h 60%% -R 'kitty +kitten icat %s'",
--                                 vim.fn.shellescape(file_path)
--                             )
--                             vim.fn.system(cmd)
--                         end,
--                     },
--                 },
--             },
--         }
--
--         -- Keymap for finding images
--         vim.keymap.set('n', '<leader>im', function()
--             require('telescope.builtin').find_files({
--                 prompt_title = "Image Finder",
--                 file_ignore_patterns = { "node_modules", ".git" },
--                 find_command = { "rg", "--files", "--iglob", "*.{png,jpg,jpeg,gif}" },
--             })
--         end, { desc = 'Find images and preview them in a floating tmux popup' })
--     end,
-- }

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-media-files.nvim', -- Correct capitalization
    },
    tag = '0.1.6',
    config = function()
        local telescope = require('telescope')

        telescope.setup {
            extensions = {
                media_files = {
                    filetypes = { "png", "jpg", "jpeg", "mp4", "webm", "pdf" },
                    find_cmd = "rg", -- Use ripgrep to find media files
                },
            },
        }

        -- Load the media_files extension
        telescope.load_extension('media_files')

        -- Set keymaps
        local keymap = vim.keymap.set
        keymap('n', '<leader><leader>', '<cmd>Telescope find_files<cr>', { desc = 'Fuzzy find files in cwd' })
        keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Search for text in cwd' })
        keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'List open buffers' })
        keymap('n', '<leader>fs', '<cmd>Telescope git_status<cr>', { desc = 'Find git status' })
        keymap('n', '<leader>fc', '<cmd>Telescope git_commits<cr>', { desc = 'Find git commits' })
        keymap('n', '<leader>mm', '<cmd>Telescope media_files<CR>', { desc = 'Find and preview media files' })

        keymap('n', '/', function()
            require('telescope.builtin').current_buffer_fuzzy_find()
        end, { desc = 'Search in current buffer' })
    end,
}
