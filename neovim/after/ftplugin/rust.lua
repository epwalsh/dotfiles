local wk = require "which-key"

-- NOTE: folds now managed by aerial.nvim.
-- vim.opt_local.foldmethod = "expr"
-- vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt_local.foldtext = ""
-- vim.opt_local.foldlevelstart = 1

local group = vim.api.nvim_create_augroup("rust", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = group,
  pattern = "*.rs",
  callback = function()
    wk.add({
      {
        "<CR>",
        function()
          local builtin = require "telescope.builtin"
          builtin.lsp_definitions { reuse_win = true }
        end,
        desc = "Go to definition",
      },
    }, { buffer = true })
  end,
})
