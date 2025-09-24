return {
	"nvim-telescope/telescope.nvim",
	branch = "master", -- using master to fix issues with deprecated to definition warnings
	-- '0.1.x' for stable ver.
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"andrew-george/telescope-themes",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local builtin = require("telescope.builtin")
		local actions = require("telescope.actions")
		local open_with_trouble = require("trouble.sources.telescope").open

		-- Use this to add more results without clearing the trouble list

		local add_to_trouble = require("trouble.sources.telescope").add

		-- local telescope = require("telescope")

		telescope.setup({
			defaults = {},
		})
		telescope.load_extension("fzf")
		telescope.load_extension("themes")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				-- mappings = {
				-- 	i = {
				-- 		["<C-k>"] = actions.move_selection_previous,
				-- 		["<C-j>"] = actions.move_selection_next,
				-- 	},
				-- },

				mappings = {
					i = { ["<c-t>"] = open_with_trouble },
					n = { ["<c-t>"] = open_with_trouble },
				},
			},
			pickers = {
				git_commits = {
					previewer = require("telescope.previewers").git_commit_diff_to_parent.new({}), -- full diff against its parent
					mappings = {
						i = {
							["<C-l>"] = require("telescope.actions").cycle_previewers_next,
							["<C-h>"] = require("telescope.actions").cycle_previewers_prev,
						},
					},
				},
			},
			extensions = {
				themes = {
					enable_previewer = true,
					enable_live_preview = true,
					persist = {
						enabled = true,
						path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
					},
				},
			},
		})

		-- Keymaps

		vim.keymap.set("n", "/", function()
			require("telescope.builtin").current_buffer_fuzzy_find()
		end, { desc = "Search in current buffer" })
		vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
		vim.keymap.set("n", "<leader>pWs", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end, { desc = "Find Connected Words under cursor" })

		vim.keymap.set(
			"n",
			"<leader>ths",
			"<cmd>Telescope themes<CR>",
			{ noremap = true, silent = true, desc = "Theme Switcher" }
		)
		vim.keymap.set("n", "<leader>gcb", function()
			require("telescope.builtin").git_commits()
		end, { desc = "Git Commits with Diff" })
	end,
}
