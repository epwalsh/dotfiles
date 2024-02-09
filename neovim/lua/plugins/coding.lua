---@diagnostic disable: inject-field

local util = require "core.util"

return {
  -------------
  -- General --
  -------------
  {
    "jiangmiao/auto-pairs",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "tpope/vim-surround",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "hrsh7th/vim-vsnip",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      vim.g.vsnip_snippet_dir = vim.fn.expand "~" .. "/dotfiles/neovim/snippets"
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    -- cmd = "IncRename",
    config = function(_, _)
      require("inc_rename").setup()
    end,
    init = function()
      local wk = require "which-key"

      wk.register({
        ["<leader>"] = {
          name = "Rename",
          r = {
            function()
              return ":IncRename " .. vim.fn.expand "<cword>"
            end,
            "Rename",
          },
        },
      }, {
        expr = true,
      })
    end,
  },

  {
    "ervandew/supertab",
    lazy = true,
    event = { "InsertEnter" },
  },

  {
    "scrooloose/nerdcommenter",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    init = function()
      -- Add spaces after comment delimiters by default
      vim.g.NERDSpaceDelims = 1
      -- Use compact syntax for prettified multi-line comments
      vim.g.NERDCompactSexyComs = 1
      -- Align line-wise comment delimiters flush left instead of following code indentation
      vim.g.NERDDefaultAlign = "left"
    end,
  },

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

      wk.register {
        ["<leader>s"] = {
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
          "Start interpreter",
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
