---@diagnostic disable: inject-field

return {
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
    -- cmd = { "Git" },
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
