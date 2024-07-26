local picker_name = "telescope.nvim"
-- local picker_name = "mini.pick"
-- local picker_name = "fzf-lua"

return {
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = true,
    opts = {
      markdown = {
        headline_highlights = { "Headline1", "Headline2", "Headline3" },
        bullet_highlights = { "Headline1", "Headline2", "Headline3" },
        bullets = { "❯", "❯", "❯", "❯" },
        dash_string = "⎯",
        fat_headlines = false,
      },
    },
    config = function(_, opts)
      local bg = "#2B2B2B"

      vim.api.nvim_set_hl(0, "Headline1", { fg = "#33ccff", bg = bg })
      vim.api.nvim_set_hl(0, "Headline2", { fg = "#00bfff", bg = bg })
      vim.api.nvim_set_hl(0, "Headline3", { fg = "#0099cc", bg = bg })
      vim.api.nvim_set_hl(0, "CodeBlock", { bg = bg })
      vim.api.nvim_set_hl(0, "Dash", { fg = "#D19A66", bold = true })

      require("headlines").setup(opts)
    end,
  },

  {
    dir = "~/github.com/epwalsh/obsidian.nvim",
    name = "obsidian",
    lazy = true,
    ft = "markdown",
    -- event = {
    --   "BufReadPre " .. vim.fn.resolve(vim.fn.expand "~/Obsidian/notes") .. "/*",
    --   "BufNewFile " .. vim.fn.resolve(vim.fn.expand "~/Obsidian/notes") .. "/*",
    -- },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-cmp",
      "headlines.nvim",
      picker_name,
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
          d = { "<cmd>ObsidianDailies -10 0<cr>", "Daily notes" },
          p = { "<cmd>ObsidianPasteImg<cr>", "Paste image" },
          q = { "<cmd>ObsidianQuickSwitch<cr>", "Quick switch" },
          s = { "<cmd>ObsidianSearch<cr>", "Search" },
          t = { "<cmd>ObsidianTags<cr>", "Tags" },
          l = { "<cmd>ObsidianLinks<cr>", "Links" },
          b = { "<cmd>ObsidianBacklinks<cr>", "Backlinks" },
          -- b = { "<cmd>luafile lua/backlinks.lua<cr>", "Backlinks" },
          m = { "<cmd>ObsidianTemplate<cr>", "Template" },
          n = { "<cmd>ObsidianQuickSwitch nav<cr>", "Nav" },
          r = { "<cmd>ObsidianRename<cr>", "Rename" },
          c = { "<cmd>ObsidianTOC<cr>", "Contents (TOC)" },
          w = {
            function()
              local Note = require "obsidian.note"
              ---@type obsidian.Client
              local client = require("obsidian").get_client()
              assert(client)

              local picker = client:picker()
              if not picker then
                client.log.err "No picker configured"
                return
              end

              ---@param dt number
              ---@return obsidian.Path
              local function weekly_note_path(dt)
                return client.dir / os.date("notes/weekly/week-of-%Y-%m-%d.md", dt)
              end

              ---@param dt number
              ---@return string
              local function weekly_alias(dt)
                local alias = os.date("Week of %A %B %d, %Y", dt)
                assert(type(alias) == "string")
                return alias
              end

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

              local current_week_dt = os.time() + (offset_start * 3600 * 24)
              ---@type obsidian.PickerEntry
              local weeklies = {}
              for week_offset = 1, -2, -1 do
                local week_dt = current_week_dt + (week_offset * 3600 * 24 * 7)
                local week_alias = weekly_alias(week_dt)
                local week_display = week_alias
                local path = weekly_note_path(week_dt)

                if week_offset == 0 then
                  week_display = week_display .. " @current"
                elseif week_offset == 1 then
                  week_display = week_display .. " @next"
                elseif week_offset == -1 then
                  week_display = week_display .. " @last"
                end

                if not path:is_file() then
                  week_display = week_display .. " ➡️ create"
                end

                weeklies[#weeklies + 1] = {
                  value = week_dt,
                  display = week_display,
                  ordinal = week_display,
                  filename = tostring(path),
                }
              end

              picker:pick(weeklies, {
                prompt_title = "Weeklies",
                callback = function(dt)
                  local path = weekly_note_path(dt)
                  ---@type obsidian.Note
                  local note
                  if path:is_file() then
                    note = Note.from_file(path)
                  else
                    note = client:create_note {
                      id = path.name,
                      dir = path:parent(),
                      title = weekly_alias(dt),
                      tags = { "weekly-notes" },
                    }
                  end
                  client:open_note(note)
                end,
              })
            end,
            "Weeklies",
          },
        },
      }

      wk.register({
        ["<leader>o"] = {
          name = "Obsidian",
          e = {
            function()
              local title = vim.fn.input { prompt = "Enter title (optional): " }
              vim.cmd("ObsidianExtractNote " .. title)
            end,
            "Extract text into new note",
          },
          l = {
            function()
              vim.cmd "ObsidianLink"
            end,
            "Link text to an existing note",
          },
          n = {
            function()
              vim.cmd "ObsidianLinkNew"
            end,
            "Link text to a new note",
          },
          t = {
            function()
              vim.cmd "ObsidianTags"
            end,
            "Tags",
          },
        },
      }, {
        mode = "v",
      })
    end,
    opts = {
      workspaces = {
        {
          name = "notes",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/notes",
          -- path = "~/Obsidian/notes",
        },
        {
          name = "demo",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/demo",
          overrides = {
            daily_notes = {
              date_format = "%Y-%m-%d",
              folder = "daily",
              template = "daily.md",
              alias_format = vim.NIL,
              default_tags = vim.NIL,
            },
            new_notes_location = "current_dir",
            -- notes_subdir = vim.NIL,
            -- disable_frontmatter = true,
          },
        },
        -- {
        --   name = "no-vault",
        --   path = function()
        --     return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        --   end,
        --   strict = true,
        --   overrides = {
        --     notes_subdir = vim.NIL,
        --     new_notes_location = "current_dir",
        --     templates = {
        --       folder = vim.NIL,
        --     },
        --     disable_frontmatter = true,
        --   },
        -- },
      },

      notes_subdir = "notes",

      picker = {
        name = picker_name,
        note_mappings = {
          new = "<C-n>",
        },
      },

      sort_by = "modified",
      sort_reversed = true,

      open_notes_in = "vsplit",

      log_level = vim.log.levels.INFO,

      -- disable_frontmatter = true,

      wiki_link_func = "prepend_note_id",
      -- wiki_link_func = "use_alias_only",
      -- wiki_link_func = "prepend_note_path",
      -- wiki_link_func = "use_path_only",

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

      new_notes_location = "notes_subdir",

      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        substitutions = {},
      },

      daily_notes = {
        date_format = "%Y-%m-%d",
        folder = "notes/daily",
        alias_format = "%A %B %d, %Y",
        template = "daily.md",
      },

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart { "open", url } -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      follow_img_func = function(img)
        -- Open the image in the default web browser.
        vim.fn.jobstart { "qlmanage", "-p", img }
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      ---@param note obsidian.Note
      note_frontmatter_func = function(note)
        -- Add the title of the note as an alias.
        if note.title then
          note:add_alias(note.title)
        end

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

      attachments = {
        img_name_func = function()
          ---@type obsidian.Client
          local client = require("obsidian").get_client()

          local note = client:current_note()
          if note then
            return string.format("%s-", note.id)
          else
            return string.format("%s-", os.time())
          end
        end,
      },

      callbacks = {
        -- Runs at the end of `require("obsidian").setup()`.
        ---@param client obsidian.Client
        ---@diagnostic disable-next-line: unused-local
        post_setup = function(client) end,

        -- Runs anytime you enter the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        ---@diagnostic disable-next-line: unused-local
        enter_note = function(client, note)
          if note.path.stem == "nav" then
            vim.opt.wrap = false
          end
        end,

        -- Runs anytime you leave the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        ---@diagnostic disable-next-line: unused-local
        leave_note = function(client, note)
          vim.api.nvim_buf_call(note.bufnr or 0, function()
            vim.cmd "silent w"
          end)
        end,

        -- Runs right before writing the buffer for a note.
        ---@param client obsidian.Client
        ---@param note obsidian.Note
        ---@diagnostic disable-next-line: unused-local
        pre_write_note = function(client, note)
          -- note:add_field("modified", os.date())
        end,

        -- Runs anytime the workspace is set/changed.
        ---@param client obsidian.Client
        ---@param workspace obsidian.Workspace
        ---@diagnostic disable-next-line: unused-local
        post_set_workspace = function(client, workspace)
          -- TODO: make sure this only runs when we're inside a vault.
          -- client.log.info("Changing directory to %s", workspace.path)
          -- vim.cmd.cd(tostring(workspace.path))
        end,
      },

      ui = {
        enable = true, -- set to false to disable all additional syntax features
        update_debounce = 800, -- update delay after a text change (in milliseconds)
        max_file_length = 5000,

        callouts = {
          -- This is how the Callout will be rendered after the char
          -- ex: <char>Note
          ["Note"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutNote",
          },
          ["Abstract"] = {
            aliases = {
              "Summary",
              "Tldr",
            },
            char = "",
            hl_group = "ObsidianCalloutAbstract",
          },
          ["Info"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutInfo",
          },
          ["Todo"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutTodo",
          },
          ["Tip"] = {
            aliases = {
              "Hint",
              "Important",
            },
            char = "󰈸",
            hl_group = "ObsidianCalloutTip",
          },
          ["Success"] = {
            aliases = {
              "Check",
              "Done",
            },
            char = "󰄬",
            hl_group = "ObsidianCalloutSuccess",
          },
          ["Question"] = {
            aliases = {
              "Help",
              "FAQ",
            },
            char = "",
            hl_group = "ObsidianCalloutQuestion",
          },
          ["Warning"] = {
            aliases = {
              "Caution",
              "Attentition",
            },
            char = "",
            hl_group = "ObsidianCalloutWarning",
          },
          ["Failure"] = {
            aliases = {
              "Fail",
              "Missing",
            },
            char = "",
            hl_group = "ObsidianCalloutFailure",
          },
          ["Danger"] = {
            aliases = {
              "Error",
            },
            char = "",
            hl_group = "ObsidianCalloutDanger",
          },
          ["Bug"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutBug",
          },
          ["Example"] = {
            aliases = {},
            char = "",
            hl_group = "ObsidianCalloutExample",
          },
          ["Quote"] = {
            aliases = {},
            char = "󱆨",
            hl_group = "ObsidianCalloutQuote",
          },
        },

        -- Define how various check-boxes are displayed
        checkboxes = {
          -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
          [" "] = { order = 1, char = "󰄱", hl_group = "ObsidianTodo" },
          ["x"] = { order = 2, char = "", hl_group = "ObsidianDone" },
          [">"] = { order = 3, char = "", hl_group = "ObsidianRightArrow" },
          ["!"] = { order = 4, char = "", hl_group = "ObsidianTilde" },
          ["~"] = { order = 5, char = "󰰱", hl_group = "ObsidianTilde" },
          ["?"] = { order = 6, char = "", hl_group = "ObsidianTilde" },
        },

        bullets = { char = "•", hl_group = "ObsidianBullet" },
        external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
        reference_text = { hl_group = "ObsidianRefText" },
        highlight_text = { hl_group = "ObsidianHighlightText" },
        tags = { hl_group = "ObsidianTag" },
        block_ids = { hl_group = "ObsidianBlockID" },

        hl_groups = {
          -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
          ObsidianTodo = { bold = true, fg = "#f78c6c" },
          ObsidianDone = { bold = true, fg = "#89ddff" },
          ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
          ObsidianTilde = { bold = true, fg = "#ff5370" },
          ObsidianBullet = { bold = true, fg = "#89ddff" },
          -- ObsidianRefText = { underline = true, fg = "#cc99ff" },
          -- ObsidianExtLinkIcon = { fg = "#cc99ff" },
          ObsidianRefText = { underline = true, fg = "#c792ea" },
          ObsidianExtLinkIcon = { fg = "#c792ea" },
          ObsidianTag = { italic = true, fg = "#89ddff" },
          ObsidianBlockID = { italic = true, fg = "#89ddff" },
          ObsidianHighlightText = { bg = "#75662e" },
          -- Callout highlights
          ObsidianCalloutNote = { bg = "#1072b8" },
          ObsidianCalloutAbstract = { bg = "#d7e6fa" },
          ObsidianCalloutInfo = { bg = "#6a93e5" },
          ObsidianCalloutTodo = { bg = "#6a93e5" },
          ObsidianCalloutTip = { bg = "#d7e6fa" },
          ObsidianCalloutSuccess = { bg = "#9fc360" },
          ObsidianCalloutQuestion = { bg = "#faebd7" },
          ObsidianCalloutWarning = { bg = "#faebd7" },
          ObsidianCalloutFailure = { bg = "#ee5d5c" },
          ObsidianCalloutDanger = { bg = "#ee5d5c" },
          ObsidianCalloutBug = { bg = "#ee5d5c" },
          ObsidianCalloutExample = { bg = "#c792ea" },
          ObsidianCalloutQuote = { bg = "#E9F0FD" },
        },
      },
    },
  },
}
