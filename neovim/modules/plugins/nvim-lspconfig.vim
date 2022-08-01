" Rust.
"
lua require("lspconfig").rust_analyzer.setup({})

" Go.
"
lua require("lspconfig").gopls.setup({})

" Python.
"
" NOTE: We're using two different language servers here, 'Jedi LS' and
" 'Pyright', because they both have different strengths.
"
" Jedi has great LS capabilities, but only checks for syntax errors, so it
" doesn't help with linting and type-checking.
"
" On the other hand, Pyright is great for linting and type-checking, but its
" other LS capabilities are not great, so we disable Pyright as a completion
" provider to avoid duplicate suggestions from nvim-cmp.
lua << EOF
local on_attach = function(client, bufnr)
    if client.name == 'pyright' then
        --- Renaming doesn't work properly unless we only have a single
        --- rename provider, so we disable it for pyright.
        --- See https://github.com/neovim/neovim/issues/15899
        client.server_capabilities.renameProvider = false
        --- For neovim < 0.8, use:
        --- client.resolved_capabilities.rename = false

        --- For some reason doing rc.completion = false, doesn't work, so
        --- we disable it in a different way:
        client.server_capabilities.completionProvider = false
    end
end

require("lspconfig")["jedi_language_server"].setup {
    on_attach = on_attach,
}

require("lspconfig")["pyright"].setup {
    on_attach = on_attach,
}
EOF
