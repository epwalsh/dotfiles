lua << EOF
require("dressing").setup({
    input = {
        enable = true,
        --- Set window transparency to 0.
        winblend = 0,
    },
})
EOF
