-- Expand
vim.keymap.set({ "i", "s" }, "<c-j>", "vsnip#expandable() ? '<Plug>(vsnip-expand)' : '<C-j>'", { expr = true })

-- Expand or jump
vim.keymap.set({ "i", "s" }, "<c-l>", "vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'", { expr = true })

-- Jump forward or backward
vim.keymap.set({ "i", "s" }, "<Tab>", "vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<Tab>'", { expr = true })
vim.keymap.set({ "i", "s" }, "<S-Tab>", "vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<Tab>'", { expr = true })
