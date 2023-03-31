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
    "smjonas/inc-rename.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
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

  --------------
  -- Markdown --
  --------------
  {
    dir = "~/github.com/epwalsh/obsidian.nvim",
    name = "obsidian",
    lazy = true,
    event = { "BufReadPre " .. os.getenv "HOME" .. "/notes/**.md" }, -- can't use '~/' for some reason
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-cmp",
      "telescope.nvim",
      "tabular",
      "vim-markdown",
    },
    opts = {
      dir = "~/notes",
      notes_subdir = "notes",
      -- disable_frontmatter = true,
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      completion = {
        nvim_cmp = true,
      },
      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)

      vim.keymap.set("n", "gf", function()
        if require("obsidian").util.cursor_on_markdown_link() then
          return "<cmd>ObsidianFollowLink<CR>"
        else
          return "gf"
        end
      end, { noremap = false, expr = true })
    end,
  },

  {
    "godlygeek/tabular",
    lazy = true,
    ft = "markdown",
  },

  {
    "preservim/vim-markdown",
    lazy = true,
    ft = "markdown",
    init = function()
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_new_list_item_indent = 2
      vim.g.vim_markdown_folding_disabled = 1
    end,
  },

  {
    "ferrine/md-img-paste.vim",
    lazy = true,
    ft = "markdown",
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
