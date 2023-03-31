return {
	{
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = { "InsertEnter" },
		dependencies = {
			"nvim-lspconfig",
			"onsails/lspkind.nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"uga-rosa/cmp-dictionary",
			"hrsh7th/cmp-vsnip",
		},
		opts = {},
		config = function(_, _)
			local cmp = require("cmp")
			local lspkind = require("lspkind")

			-- Load custom github handles source from ./lua/cmp/github_handles.lua
			cmp.register_source("github_handles", require("cmp.github_handles").new())

			-- General setup.
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = {
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-e>"] = cmp.mapping.close(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Insert,
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "nvim_lua" },
					{
						name = "path",
						option = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
					{ name = "emoji" },
					{ name = "vsnip" },
					{ name = "buffer", keyword_length = 3 },
					{ name = "calc" },
					{ name = "dictionary" },
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						menu = {
							buffer = "[Buffer]",
							nvim_lsp = "[LSP]",
							obsidian = "[Obsidian]",
							obsidian_new = "[Obsidian]",
						},
					}),
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			-- Filetype specific setup.
			cmp.setup.filetype("gitcommit", {
				sources = cmp.config.sources({
					{ name = "buffer", keyword_length = 3 },
					{
						name = "path",
						option = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
					{ name = "emoji" },
					{ name = "github_handles" }, -- from ./lua/cmp/github_handles.lua
				}),
			})

			cmp.setup.filetype("make", {
				sources = cmp.config.sources({
					{ name = "buffer", keyword_length = 3 },
					{
						name = "path",
						option = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
				}),
			})

			cmp.setup.filetype("markdown", {
				sources = cmp.config.sources({
					{ name = "buffer", keyword_length = 3 },
					{
						name = "path",
						option = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
					{ name = "vsnip" },
					{ name = "calc" },
					{ name = "dictionary", keyword_length = 3 },
				}),
			})

			cmp.setup.filetype("yaml", {
				sources = cmp.config.sources({
					{ name = "buffer", keyword_length = 3 },
					{
						name = "path",
						option = {
							get_cwd = function(_)
								return vim.fn.getcwd()
							end,
						},
					},
					{ name = "calc" },
					{ name = "emoji", option = { insert = true } },
					{ name = "dictionary", keyword_length = 3 },
				}),
			})

			-- cmp-dictionary setup
			require("cmp_dictionary").setup({
				dic = {
					["markdown"] = { vim.fs.normalize("~/.config/nvim/spell/en.utf-8.add"), "/usr/share/dict/words" },
				},
			})
		end,
	},
}
