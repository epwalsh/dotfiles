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
    config = function(_, opts)
      -- Setup obsidian.nvim
      require("obsidian").setup(opts)

      -- Create which-key mappings for common commands.
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

      -- Extra custom commands.
      vim.api.nvim_create_user_command("Weekdays", "ObsidianTemplate weekdays.md", {})
    end,
    opts = {
      dir = "~/notes",
      notes_subdir = "notes",

      finder = "telescope.nvim",
      -- finder = "fzf.vim",

      sort_by = "modified",
      sort_reversed = true,

      open_notes_in = "current",

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
        substitutions = {
          weekdays = function()
            local client = assert(require("obsidian").get_client())

            local day_of_week = os.date "%A"
            assert(type(day_of_week) == "string")

            ---@type integer
            local offset_start
            if day_of_week == "Sunday" then
              offset_start = 1
            elseif day_of_week == "Monday" then
              offset_start = 0
            elseif day_of_week == "Tuesday" then
              offset_start = -1
            elseif day_of_week == "Wednesday" then
              offset_start = -2
            elseif day_of_week == "Thursday" then
              offset_start = -3
            elseif day_of_week == "Friday" then
              offset_start = -4
            elseif day_of_week == "Saturday" then
              offset_start = 2
            end
            assert(offset_start)

            local lines = {}
            for offset = offset_start, offset_start + 4 do
              local note = client:daily(offset)
              lines[#lines + 1] =
                string.format("- [[%s|%s]]", note.id, os.date("%A, %B %-d", os.time() + offset * 3600 * 24))
            end

            return table.concat(lines, "\n")
          end,
        },
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
