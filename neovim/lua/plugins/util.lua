---@diagnostic disable: inject-field

return {
  -- Helper for keybindings.
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

  -- Quickly jump around the buffer.
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

  -- Opens a link on GitHub to current line.
  {
    "ruanyl/vim-gh-line",
    lazy = true,
    event = { "BufEnter" },
  },

  -- Gives us the Rename command.
  {
    "wojtekmach/vim-rename",
    lazy = true,
    cmd = { "Rename" },
  },

  -- Do git stuff from within neovim.
  {
    "tpope/vim-fugitive",
    lazy = false,
  },

  -- Multi-cursor support.
  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "smoka7/hydra.nvim",
    },
    config = function()
      local mc = require "multicursors"
      local config = require "multicursors.config"

      local function swap_keys(keys, source, target)
        keys[target] = keys[source]
        keys[source] = nil
      end

      -- See https://github.com/smoka7/multicursors.nvim/blob/main/lua/multicursors/config.lua
      swap_keys(config.normal_keys, "j", "<C-j>")
      swap_keys(config.normal_keys, "k", "<C-k>")
      swap_keys(config.normal_keys, "<C-n>", "<C-c>")

      mc.setup(config)
    end,
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        "<C-n>",
        "<cmd>MCstart<cr>",
        mode = { "v", "n" },
        desc = "Multi-cursor start with word under cursor",
      },
      {
        "<C-c>",
        "<cmd>MCunderCursor<cr>",
        mode = { "v", "n" },
        desc = "Multi-cursor start with char under cursor",
      },
    },
  },

  -- Multi-cursor.
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  --   init = function()
  --     vim.g["VM_default_mappings"] = 0
  --     vim.g.VM_maps = {
  --       ["Add Cursors Down"] = "<C-j>",
  --       ["Add Cursors Up"] = "<C-k>",
  --       ["Add Cursor At Pos"] = "<C-e>",
  --     }
  --   end,
  -- },

  -- Do MORE git stuff from within neovim.
  {
    "pwntester/octo.nvim",
    lazy = true,
    cmd = { "Octo" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "kyazdani42/nvim-web-devicons",
    },
    opts = {},
  },

  -- Toggle comments.
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
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  {
    "skywind3000/asyncrun.vim",
    lazy = true,
    cmd = { "AsyncRun", "AsyncStop", "AsyncReset" },
    init = function()
      vim.g.asyncrun_mode = "term"
      vim.keymap.set("n", "!", ":AsyncRun ")
    end,
  },

  { "echasnovski/mini.doc", version = "*" },

  {
    dir = "~/github.com/epwalsh/pomo.nvim",
    name = "pomo",
    lazy = true,
    cmd = { "TimerStart", "TimerStop", "TimerRepeat" },
    dependencies = {
      -- "rcarriga/nvim-notify",
      "telescope.nvim",
    },
    opts = {
      notifiers = {
        { name = "Default", opts = { sticky = false } },
        { name = "System" },
      },
      timers = {
        Stretching = {
          { name = "Default" },
          { name = "System" },
        },
        Break = {
          { name = "Default" },
          { name = "System" },
        },
      },
    },
    config = function(_, opts)
      require("pomo").setup(opts)
      require("telescope").load_extension "pomodori"
      local wk = require "which-key"

      wk.register {
        ["<leader>p"] = {
          name = "Pomodori",
          t = {
            function()
              require("telescope").extensions.pomodori.timers(require("telescope.themes").get_dropdown())
            end,
            "Telescope",
          },
        },
      }
    end,
  },
}
