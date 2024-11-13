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
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show { global = false }
        end,
        desc = "Buffer local keymaps (which-key)",
      },
    },
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
    init = function()
      vim.g.gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '
    end,
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
    version = "v2.0",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    config = function()
      local mc = require "multicursors"
      local config = require "multicursors.config"
      local utils = require "multicursors.utils"

      local function swap_keys(keys, source, target)
        keys[target] = keys[source]
        keys[source] = nil
      end

      -- See https://github.com/smoka7/multicursors.nvim/blob/main/lua/multicursors/config.lua
      swap_keys(config.normal_keys, "j", "<C-j>")
      swap_keys(config.normal_keys, "k", "<C-k>")
      swap_keys(config.normal_keys, "<C-n>", "<C-c>")

      config.create_commands = false

      mc.setup(config)

      -- Monkey-patch the exit function to re-enable autopairs.
      local exit_func = utils.exit
      utils.exit = function()
        require("core.util").enable_autopairs()
        exit_func()
      end
    end,
    keys = {
      {
        "<C-n>",
        function()
          local mc = require "multicursors"
          local util = require "core.util"

          util.disable_autopairs()
          mc.start()
        end,
        mode = { "v", "n" },
        desc = "Multi-cursor start with word under cursor",
      },
      {
        "<C-c>",
        function()
          local mc = require "multicursors"
          local util = require "core.util"

          util.disable_autopairs()
          mc.new_under_cursor()
        end,
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

  -- {
  --   "jiangmiao/auto-pairs",
  --   lazy = true,
  --   event = { "BufReadPre", "BufNewFile" },
  -- },
  -- {
  --   "altermo/ultimate-autopair.nvim",
  --   event = { "InsertEnter", "CmdlineEnter" },
  --   -- branch = "v0.6", --recommended as each new version will have breaking changes
  --   opts = {
  --     --Config goes here
  --   },
  -- },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
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
    cmd = { "TimerStart", "TimerStop", "TimerRepeat", "TimerSession" },
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
        ["Short Break"] = {
          { name = "Default", opts = { sticky = true } },
          { name = "System" },
        },
      },
      sessions = {
        Pomodoro = {
          { name = "Work", duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work", duration = "25m" },
          { name = "Short Break", duration = "5m" },
        },
      },
    },
    config = function(_, opts)
      require("pomo").setup(opts)
      require("telescope").load_extension "pomodori"
      local wk = require "which-key"

      wk.add {
        { "<leader>p", group = "Pomodori" },
        {
          "<leader>pt",
          function()
            require("telescope").extensions.pomodori.timers(require("telescope.themes").get_dropdown())
          end,
          desc = "Telescope",
        },
      }
    end,
  },
}
