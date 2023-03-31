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
    lazy = true,
    cmd = { "Git" },
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
}
