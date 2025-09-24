return {
	"hrsh7th/nvim-cmp",
	-- event = "InsertEnter",
	branch = "main", -- fix for deprecated functions coming in nvim 0.13
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
		},
		"saadparwaiz1/cmp_luasnip", -- autocompletion
		"rafamadriz/friendly-snippets", -- snippets
		"nvim-treesitter/nvim-treesitter",
		"onsails/lspkind.nvim", -- vs-code pictograms
		"roobert/tailwindcss-colorizer-cmp.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local has_luasnip, luasnip = pcall(require, "luasnip")
		local lspkind = require("lspkind")
		local colorizer = require("tailwindcss-colorizer-cmp").formatter

		local rhs = function(keys)
			return vim.api.nvim_replace_termcodes(keys, true, true, true)
		end

		local lsp_kinds = {
			Class = " ",
			Color = " ",
			Constant = " ",
			Constructor = " ",
			Enum = " ",
			EnumMember = " ",
			Event = " ",
			Field = " ",
			File = " ",
			Folder = " ",
			Function = " ",
			Interface = " ",
			Keyword = " ",
			Method = " ",
			Module = " ",
			Operator = " ",
			Property = " ",
			Reference = " ",
			Snippet = " ",
			Struct = " ",
			Text = " ",
			TypeParameter = " ",
			Unit = " ",
			Value = " ",
			Variable = " ",
		}

		local column = function()
			local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col
		end

		local in_snippet = function()
			local session = require("luasnip.session")
			local node = session.current_nodes[vim.api.nvim_get_current_buf()]
			if not node then
				return false
			end
			local snippet = node.parent.snippet
			local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end()
			local pos = vim.api.nvim_win_get_cursor(0)
			if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
				return true
			end
		end

		local in_whitespace = function()
			local col = column()
			return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match("%s")
		end

		local in_leading_indent = function()
			local col = column()
			local line = vim.api.nvim_get_current_line()
			local prefix = line:sub(1, col)
			return prefix:find("^%s*$")
		end

		local shift_width = function()
			if vim.o.softtabstop <= 0 then
				return vim.fn.shiftwidth()
			else
				return vim.o.softtabstop
			end
		end

		local smart_bs = function(dedent)
			local keys = nil
			if vim.o.expandtab then
				if dedent then
					keys = rhs("<C-D>")
				else
					keys = rhs("<BS>")
				end
			else
				local col = column()
				local line = vim.api.nvim_get_current_line()
				local prefix = line:sub(1, col)
				if in_leading_indent() then
					keys = rhs("<BS>")
				else
					local previous_char = prefix:sub(#prefix, #prefix)
					if previous_char ~= " " then
						keys = rhs("<BS>")
					else
						keys = rhs("<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>")
					end
				end
			end
			vim.api.nvim_feedkeys(keys, "nt", true)
		end

		local smart_tab = function(_opts)
			local keys = nil
			if vim.o.expandtab then
				keys = "<Tab>"
			else
				local col = column()
				local line = vim.api.nvim_get_current_line()
				local prefix = line:sub(1, col)
				local in_leading_indent = prefix:find("^%s*$")
				if in_leading_indent then
					keys = "<Tab>"
				else
					local sw = shift_width()
					local previous_char = prefix:sub(#prefix, #prefix)
					local previous_column = #prefix - #previous_char + 1
					local current_column = vim.fn.virtcol({ vim.fn.line("."), previous_column }) + 1
					local remainder = (current_column - 1) % sw
					local move = remainder == 0 and sw or sw - remainder
					keys = (" "):rep(move)
				end
			end
			vim.api.nvim_feedkeys(rhs(keys), "nt", true)
		end

		local select_next_item = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end

		local select_prev_item = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end

		local confirm = function(entry)
			local behavior = cmp.ConfirmBehavior.Replace
			if entry then
				local completion_item = entry.completion_item
				local newText = ""
				if completion_item.textEdit then
					newText = completion_item.textEdit.newText
				elseif type(completion_item.insertText) == "string" and completion_item.insertText ~= "" then
					newText = completion_item.insertText
				else
					newText = completion_item.word or completion_item.label or ""
				end

				local diff_after = math.max(0, entry.replace_range["end"].character + 1) - entry.context.cursor.col
				if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
					behavior = cmp.ConfirmBehavior.Insert
				end
			end
			cmp.confirm({ select = true, behavior = behavior })
		end

		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			experimental = { ghost_text = false },
			completion = { completeopt = "menu,menuone,noinsert" },
			window = {
				documentation = { border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" } },
				completion = { border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" } },
			},
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "luasnip" },
				{ name = "lazydev" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "tailwindcss-colorizer-cmp" },
			}),
			mapping = cmp.mapping.preset.insert({
				["<C-e>"] = cmp.mapping.abort(),
				["<C-d>"] = cmp.mapping(function()
					cmp.close_docs()
				end, { "i", "s" }),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-j>"] = cmp.mapping(select_next_item),
				["<C-k>"] = cmp.mapping(select_prev_item),
				["<C-n>"] = cmp.mapping(select_next_item),
				["<C-p>"] = cmp.mapping(select_prev_item),
				["<Down>"] = cmp.mapping(select_next_item),
				["<Up>"] = cmp.mapping(select_prev_item),
				["<C-y>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						confirm(cmp.get_selected_entry())
					else
						fallback()
					end
				end, { "i", "s" }),
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						confirm(cmp.get_selected_entry())
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
						luasnip.jump(-1)
					elseif in_leading_indent() then
						smart_bs(true)
					elseif in_whitespace() then
						smart_bs()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<Tab>"] = cmp.mapping(function(_fallback)
					if cmp.visible() then
						local entries = cmp.get_entries()
						if #entries == 1 then
							confirm(entries[1])
						else
							cmp.select_next_item()
						end
					elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					elseif in_whitespace() then
						smart_tab()
					else
						cmp.complete()
					end
				end, { "i", "s" }),
			}),
			formatting = {
				format = function(entry, vim_item)
					vim_item.kind = string.format("%s %s", lsp_kinds[vim_item.kind] or "", vim_item.kind)
					vim_item.menu = ({
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[LuaSnip]",
						nvim_lua = "[Lua]",
						latex_symbols = "[LaTeX]",
					})[entry.source.name]
					vim_item = lspkind.cmp_format({ maxwidth = 25, ellipsis_char = "..." })(entry, vim_item)
					if entry.source.name == "nvim_lsp" then
						vim_item = colorizer(entry, vim_item)
					end
					return vim_item
				end,
			},
		})

		-- ===== Clean, readable diagnostics (float + colors) =====
		-- 1) Behavior + look
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 2,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰌵 ",
				},
			},
			underline = true,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
				focusable = false,
				header = "",
				prefix = function(diag)
					local icons = { "", "", "", "󰌵" }
					return (" %s "):format(icons[diag.severity] or "")
				end,
				-- Keep text short and readable
				format = function(d)
					local msg = d.message:gsub("\n", " "):gsub("%s+", " ")
					return msg
				end,
			},
		})

		-- 2) Nice, neutral colors that work on most themes (reapplied on :colorscheme)
		local function set_diag_hl()
			-- Float container/border
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e" })
			vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#585b70", bg = "#1e1e2e" })
			vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#cdd6f4", bg = "#1e1e2e", bold = true })

			-- Diagnostics
			vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#f38ba8" })
			vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#f9e2af" })
			vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#89dceb" })
			vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#94e2d5" })
			vim.api.nvim_set_hl(0, "DiagnosticOk", { fg = "#a6e3a1" })

			-- Make the floating-window versions match
			vim.api.nvim_set_hl(0, "DiagnosticFloatingError", { link = "DiagnosticError" })
			vim.api.nvim_set_hl(0, "DiagnosticFloatingWarn", { link = "DiagnosticWarn" })
			vim.api.nvim_set_hl(0, "DiagnosticFloatingInfo", { link = "DiagnosticInfo" })
			vim.api.nvim_set_hl(0, "DiagnosticFloatingHint", { link = "DiagnosticHint" })
			vim.api.nvim_set_hl(0, "DiagnosticFloatingOk", { link = "DiagnosticOk" })

			-- Virtual text with dim bg for readability
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#f38ba8", bg = "#2a1a22" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#f9e2af", bg = "#2a2616" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#89dceb", bg = "#13222a" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#94e2d5", bg = "#102421" })
			vim.api.nvim_set_hl(0, "DiagnosticVirtualTextOk", { fg = "#a6e3a1", bg = "#112613" })
		end
		set_diag_hl()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_diag_hl,
			desc = "Reapply diagnostic highlight colors after colorscheme changes",
		})

		-- 3) Show diagnostics on hover (clear, bordered float)
		vim.o.updatetime = 250
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = function()
				if vim.b._diag_float_open then
					return
				end
				vim.b._diag_float_open = true
				vim.diagnostic.open_float(nil, { scope = "cursor" })
				-- close the flag shortly after to allow reopening on small moves
				vim.defer_fn(function()
					vim.b._diag_float_open = false
				end, 150)
			end,
			desc = "Show diagnostics in a rounded, readable float",
		})

		-- ===== Optional: Ghost text only at word boundaries =====
		local config = require("cmp.config")
		local toggle_ghost_text = function()
			if vim.api.nvim_get_mode().mode ~= "i" then
				return
			end
			local cursor_column = vim.fn.col(".")
			local current_line_contents = vim.fn.getline(".")
			local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)
			local should_enable = character_after_cursor == "" or vim.fn.match(character_after_cursor, [[\k]]) == -1
			if config.get().experimental.ghost_text ~= should_enable then
				config.set_global({ experimental = { ghost_text = should_enable } })
			end
		end
		vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, { callback = toggle_ghost_text })
	end,
}
