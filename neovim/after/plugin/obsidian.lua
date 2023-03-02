local obsidian = require("obsidian").setup({
	dir = "~/epwalsh-notes",
	notes_subdir = "notes",
	-- disable_frontmatter = true,
	note_id_func = function(title)
		-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
		local suffix = ""
		if title ~= nil then
			-- If title is given, transform it into valid file name.
			suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
		else
			-- If title is nil, just add 4 random uppercase letters to the suffix.
			for _ = 1, 4 do
				suffix = suffix .. string.char(math.random(65, 90))
			end
		end
		return tostring(os.time()) .. "-" .. suffix
	end,
	completion = {
		nvim_cmp = true,
	},
	templates = {
		subdir = "templates",
		date_format = "%Y-%m-%d-%a",
		time_format = "%H:%M",
	},
})

local au_group = vim.api.nvim_create_augroup("obsidian_extra_setup", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	group = au_group,
	pattern = tostring(obsidian.dir / "**.md"),
	callback = function()
		vim.keymap.set("n", "gf", function()
			if require("obsidian").util.cursor_on_markdown_link() then
				return "<cmd>ObsidianFollowLink<CR>"
			else
				return "gf"
			end
		end, { noremap = false, expr = true })
	end,
})
