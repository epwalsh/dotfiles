---@diagnostic disable: inject-field

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
      vim.keymap.set("n", "<leader>r", function()
        return ":IncRename " .. vim.fn.expand "<cword>"
      end, { expr = true })
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
    ft = { "python" },
    init = function()
      vim.keymap.set("n", "<leader>s", ":call VimCmdLineStartApp()<cr>")
      vim.g.cmdline_term_height = 15
      vim.g.cmdline_term_width = 80
      vim.g.cmdline_tmp_dir = "/tmp"
      vim.g.cmdline_outhl = 1
      vim.g.cmdline_app = { python = "ipython -i -c 'from rich import print, pretty; pretty.install()'" }
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

  --------------
  -- Markdown --
  --------------
  {
    "junegunn/fzf.vim",
    lazy = true,
    dependencies = {
      "junegunn/fzf",
    },
    build = function()
      vim.api.nvim_call_function("fzf#install", {})
    end,
  },

  {
    dir = "~/github.com/epwalsh/obsidian.nvim",
    name = "obsidian",
    lazy = true,
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/notes/**.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-cmp",
      "telescope.nvim",
      -- "tabular",
      -- "vim-markdown",
      -- "junegunn/fzf.vim",
    },
    opts = {
      dir = "~/notes",
      notes_subdir = "notes",

      finder = "telescope.nvim",
      -- finder = "fzf.vim",

      sort_by = "modified",
      sort_reversed = true,

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
        max_suggestions = nil,
      },

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },

      daily_notes = {
        date_format = "%Y-%m-%d",
        -- template = "nvim-daily.md",
      },

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart { "open", url } -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      note_frontmatter_func = function(note)
        -- note:add_tag "TODO"
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        -- `note.metadata` contains any manually added fields in the frontmatter.
        -- So here we just make sure those fields are kept in the frontmatter.
        if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      yaml_parser = "native",
    },
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
