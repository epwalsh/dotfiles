lua << EOF
require("dressing").setup({
    input = {
        enable = true,
        --- Set window transparency to 0.
        win_options = {
            winblend = 0,
        },
    },
})
EOF
