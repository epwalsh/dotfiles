return {
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
    ft = "markdown",
    -- event = {
    --   "BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md",
    --   "BufNewFile " .. vim.fn.expand "~" .. "/notes/**.md",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-cmp",
      "telescope.nvim",
      -- "tabular",
      -- "vim-markdown",
      -- "junegunn/fzf.vim",
    },
    init = function()
      local wk = require "which-key"

      wk.register {
        ["<leader>o"] = {
          name = "Obsidian",
          o = { "<cmd>ObsidianOpen<cr>", "Open note" },
          t = { "<cmd>ObsidianToday<cr>", "Daily Note" },
          b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
          p = { "<cmd>ObsidianPasteImg<cr>", "Paste image" },
          q = { "<cmd>ObsidianQuickSwitch<cr>", "Quick switch" },
        },
      }
    end,
    opts = {
      dir = "~/notes",
      notes_subdir = "notes",

      finder = "telescope.nvim",
      -- finder = "fzf.vim",

      sort_by = "modified",
      sort_reversed = true,

      log_level = vim.log.levels.INFO,

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
        prepend_note_path = false,
        prepend_note_id = true,
        use_path_only = false,
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
}
