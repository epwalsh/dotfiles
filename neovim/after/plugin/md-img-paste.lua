local group = vim.api.nvim_create_augroup("mdip_settings", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group,
	pattern = "markdown",
	callback = function()
		vim.keymap.set("n", "<leader>p", "call mdip#MarkdownClipboardImage()<cr>")
	end,
})
