local dashboard = require("alpha.themes.dashboard")

dashboard.section.buttons.val = {
	dashboard.button(
		"SPC f f",
		"  Find file",
		"<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob,!.git<CR>"
	),
	dashboard.button("SPC f h", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
	dashboard.button("SPC f r", "  Frecency/MRU"),
	dashboard.button("SPC f g", "  Find word", "<cmd>Telescope live_grep<cr>"),
	dashboard.button("SPC f m", "  Jump to bookmarks"),
	dashboard.button("SPC s l", "  Open last session", "<cmd>SessionManager load_last_session<CR>"),
}

require("alpha").setup(dashboard.config)
