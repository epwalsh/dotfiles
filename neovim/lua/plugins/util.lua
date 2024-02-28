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
  },
}
