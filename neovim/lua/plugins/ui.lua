return {
  -----------------
  -- Status line --
  -----------------
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      options = {
        theme = "horizon",
        -- theme = "auto", -- let 'material' set it
        -- theme = "nightfly",
        -- theme = "palenight",
      },
    },
  },

  -----------
  -- Theme --
  -----------
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
      "nvim-treesitter",
    },
    opts = {
      lualine_style = "default",
      plugins = {
        "nvim-cmp",
        "nvim-tree",
        "nvim-web-devicons",
        "trouble",
        "telescope",
      },
      styles = {
        -- functions = { bold = true },
        -- keywords = { bold = true },
        -- types = { bold = true },
      },
      custom_highlights = {
        -- These don't seem to work when set here. See below.
        -- CursorLine = { ctermbg = 236 },
        -- ColorColumn = { ctermbg = 236 },
      },
    },
    init = function()
      vim.opt.background = "dark"
      vim.g.material_style = "oceanic"
      vim.cmd "colorscheme material"
      vim.cmd "highlight CursorLine ctermbg=236"
      vim.cmd "highlight CursorLineNr cterm=None"
      vim.cmd "highlight ColorColumn ctermbg=236"
    end,
  },

  -------------
  -- Startup --
  -------------
  {
    "goolord/alpha-nvim",
    lazy = true,
    dependencies = {
      "telescope.nvim",
    },
    event = { "VimEnter" },
    opts = function()
      local dashboard = require "alpha.themes.dashboard"

      dashboard.section.buttons.val = {
        dashboard.button(
          "SPC f f",
          "  Find file",
          "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files,--glob,!.git<CR>"
        ),
        dashboard.button("SPC f h", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("SPC f r", "  Frecency/MRU"),
        dashboard.button("SPC f g", "  Find word", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("SPC f m", "  Jump to bookmarks"),
        dashboard.button("SPC s l", "  Open last session", "<cmd>SessionManager load_last_session<CR>"),
      }

      return dashboard.config
    end,
  },

  {
    "j-hui/fidget.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      window = {
        relative = "editor",
        blend = 30,
      },
    },
  },

  -----------
  -- Other --
  -----------
  {
    "RRethy/vim-illuminate",
    lazy = true,
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = { "CursorMoved", "InsertLeave" },
    config = function()
      require("illuminate").configure {
        delay = 250,
        filetypes_denylist = {
          "NvimTree",
          "Telescope",
          "telescope",
        },
      }
    end,
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        enable = true,
        --- Set window transparency to 0.
        win_options = {
          winblend = 0,
        },
      },
    },
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },

  {
    "airblade/vim-gitgutter",
    lazy = true,
    event = { "BufEnter" },
  },
}
