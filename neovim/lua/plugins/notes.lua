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
    "ibhagwan/fzf-lua",
    lazy = true,
    -- optional for icon support
    dependencies = {
      "nvim-web-devicons",
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {}
    end,
  },

  {
    "echasnovski/mini.pick",
    lazy = true,
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
      -- "mini.pick",
      -- "junegunn/fzf.vim",
      -- "fzf-lua",
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
      workspaces = {
        {
          name = "notes",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
        },
      },

      notes_subdir = "notes",

      finder = "telescope.nvim",
      -- finder = "fzf-lua",
      -- finder = "fzf.vim",
      -- finder = "mini.pick",

      sort_by = "modified",
      sort_reversed = true,

      open_notes_in = "vsplit",

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
        min_chars = 2,
        max_suggestions = nil,
        prepend_note_path = false,
        prepend_note_id = true,
        use_path_only = false,
        new_notes_location = "notes_subdir",
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
        if note.metadata ~= nil and vim.tbl_count(note.metadata) > 0 then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 200, -- update delay after a text change (in milliseconds)
        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { char = "", hl_group = "ObsidianDone" },
          [">"] = { char = "", hl_group = "ObsidianRightArrow" },
          ["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },

          -- [" "] = { char = "•", hl_group = "ObsidianTodo" },
          -- ["x"] = { char = "•", hl_group = "ObsidianDone" },
          -- [">"] = { char = "•", hl_group = "ObsidianRightArrow" },
          -- ["~"] = { char = "•", hl_group = "ObsidianTilde" },
        },
        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        -- Replace the above with this if you don't have a patched font:
        -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
        },
      },

      -- detect_all_file_extensions = true,

      yaml_parser = "native",
    },
  },
}
