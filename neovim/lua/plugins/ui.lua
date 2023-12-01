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
      sections = {
        lualine_c = { { "filename", path = 1 } }, -- how relative path instead of just filename.
        lualine_x = {
          function()
            local ok, pomo = pcall(require, "pomo")
            if not ok then
              return ""
            end

            local timer = pomo.get_first_to_finish()
            if timer == nil then
              return ""
            end

            return "󰄉 " .. tostring(timer)
          end,
          "encoding",
          "fileformat",
          "filetype",
        },
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
      "nvim-web-devicons",
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

  -- Noice.nvim handles this.
  -- {
  --   "j-hui/fidget.nvim",
  --   lazy = true,
  --   enabled = false,
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {
  --     window = {
  --       relative = "editor",
  --       blend = 30,
  --     },
  --   },
  -- },

  ---------------------------------------------
  -- UI for messages, cmdline, and popupmenu --
  ---------------------------------------------
  {
    "folke/noice.nvim",
    lazy = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = false, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = true, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true, -- add a border to hover docs and signature help
      },
      cmdline = {
        view = "cmdline",
      },
    },
  },

  {
    "rcarriga/nvim-notify",
    opts = {
      -- to prevent cursor flickering
      stages = "static",
      level = vim.log.levels.DEBUG,
      -- fps = 10,
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

  -- {
  --   "airblade/vim-gitgutter",
  --   lazy = true,
  --   event = { "BufEnter" },
  -- },

  {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    event = { "BufEnter" },
    config = function()
      require("gitsigns").setup {
        signs = {
          add = { text = "│" },
          change = { text = "│" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        yadm = {
          enable = false,
        },
      }
    end,
  },

  {
    "ggandor/leap.nvim",
    lazy = true,
    event = { "BufEnter" },
    config = function()
      local leap = require "leap"
      vim.keymap.set({ "n" }, "s", "<Plug>(leap-forward-to)")
      vim.keymap.set({ "n" }, "S", "<Plug>(leap-backward-to)")
      leap.opts.case_sensitive = true
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup {}
    end,
  },
}
