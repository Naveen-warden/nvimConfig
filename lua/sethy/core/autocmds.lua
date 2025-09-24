-- this allows the file to wrap by default on opening
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		vim.opt.wrap = true
		vim.opt.linebreak = true
		vim.opt.breakindent = true
		vim.opt.breakindentopt = "shift:2"
		-- vim.opt.showbreak = '↪ '
		print("Wrap: ON")
	end,
})
