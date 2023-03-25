-- General LSP settings
vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])
local border = {
	{ "╭", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╮", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "╯", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "╰", "FloatBorder" },
	{ "│", "FloatBorder" },
}
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	-- delay update diagnostics
	update_in_insert = false,
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

-- Rust.
require("lspconfig").rust_analyzer.setup({
	on_attach = function(client)
		require("illuminate").on_attach(client)
	end,
	settings = {
		format = {
			enable = true,
		},
	},
})

vim.cmd([[autocmd BufWritePre *.rs lua vim.lsp.buf.format()]])

-- Go.
require("lspconfig").gopls.setup({
	on_attach = function(client)
		require("illuminate").on_attach(client)
	end,
})

-- Lua.
require("lspconfig").lua_ls.setup({
	on_attach = function(client)
		require("illuminate").on_attach(client)
	end,
	commands = {
		Format = {
			function()
				require("stylua-nvim").format_file()
			end,
		},
	},
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
			format = {
				enable = false,
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
				},
			},
		},
	},
})

-- Automatic formatting.
vim.cmd([[autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync()]])

-- Python.
--
-- NOTE: We're using two different language servers here, 'Jedi LS' and
-- 'Pyright', because they both have different strengths.
--
-- Jedi has great LS capabilities, but only checks for syntax errors, so it
-- doesn't help with linting and type-checking.
--
-- On the other hand, Pyright is great for linting and type-checking, but its
-- other LS capabilities are not great, so we disable Pyright as a completion
-- provider to avoid duplicate suggestions from nvim-cmp.
local python_on_attach = function(client, bufnr)
	if client.name == "pyright" then
		--- Renaming doesn't work properly unless we only have a single
		--- rename provider, so we disable it for pyright.
		--- See https://github.com/neovim/neovim/issues/15899
		client.server_capabilities.renameProvider = false
		--- For neovim < 0.8, use:
		--- client.resolved_capabilities.rename = false

		--- For some reason doing rc.completion = false, doesn't work, so
		--- we disable it in a different way:
		client.server_capabilities.completionProvider = false
	else
		require("illuminate").on_attach(client)
	end
end

require("lspconfig")["jedi_language_server"].setup({
	on_attach = python_on_attach,
})

require("lspconfig")["pyright"].setup({
	on_attach = python_on_attach,
})
