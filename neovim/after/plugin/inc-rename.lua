require("inc_rename").setup()

vim.keymap.set("n", "rn", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
