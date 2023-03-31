return {
	-- Opens a link on GitHub to current line.
	{
		"ruanyl/vim-gh-line",
		lazy = true,
		event = { "BufEnter" },
	},

	-- Gives us the Rename command.
	{
		"wojtekmach/vim-rename",
		lazy = true,
		cmd = { "Rename" },
	},
}
