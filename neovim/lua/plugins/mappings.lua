return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      disable = {
        -- disable for vim ft so it's disabled for the command buffer ('q:')
        filetypes = { "vim" },
      },
    },
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },
}
