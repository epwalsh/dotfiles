---@diagnostic disable: inject-field

local util = require "core.util"

return {
  ------------
  -- Python --
  ------------
  {
    "Vimjas/vim-python-pep8-indent",
    lazy = true,
    ft = "python",
  },

  {
    "jalvesaq/vimcmdline",
    lazy = true,
    ft = { "python", "lua" },
    config = function(_)
      local wk = require "which-key"

      vim.g.cmdline_term_height = 15
      vim.g.cmdline_term_width = 80
      vim.g.cmdline_tmp_dir = "/tmp"
      vim.g.cmdline_outhl = 1
      vim.g.cmdline_app = { python = "ipython -i -c 'from rich import print, pretty; pretty.install()'" }
      -- we override this mapping below, so map here to something we'll probably not use.
      vim.g.cmdline_map_start = "<leader>z"

      local termbuf_filetypes = {
        python = "ipython",
        lua = "lua",
      }

      wk.add {
        {
          "<leader>s",
          function()
            vim.cmd "call cmdline#StartApp()"
            ---@diagnostic disable-next-line: undefined-field
            local ft = vim.opt_local.filetype:get()
            local termbuf_ft = termbuf_filetypes[ft]
            local termbuf_name = vim.api.nvim_get_var("cmdline_termbuf")[ft]
            local termbuf = assert(util.find_buffer_by_name(termbuf_name))
            vim.api.nvim_buf_call(termbuf, function()
              vim.opt_local.filetype = termbuf_ft
            end)
          end,
          desc = "Start interpreter",
        },
      }
    end,
  },

  ---------
  -- Lua --
  ---------
  {
    "ckipp01/stylua-nvim",
    lazy = true,
    ft = "lua",
    build = "cargo install stylua",
  },

  ----------
  -- Fish --
  ----------
  {
    "dag/vim-fish",
    lazy = true,
    ft = "fish",
  },

  ----------
  -- Rust --
  ----------
  {
    "simrat39/rust-tools.nvim",
    lazy = true,
    ft = "rust",
    dependencies = {
      "nvim-lspconfig",
    },
  },
}
