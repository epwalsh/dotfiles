return {
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle" },
    keys = { "<F2>" },
    opts = {
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    },
    init = function()
      vim.keymap.set("n", "<F2>", require("nvim-tree.api").tree.toggle)

      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1

          if not directory then
            return
          end

          -- open the tree
          require("nvim-tree.api").tree.open { path = data.file }
        end,
      })
    end,
  },
}
