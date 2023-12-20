return {
  {
    "zbirenbaum/copilot.lua",
    lazy = true,
    cmd = { "Copilot" },
    event = { "InsertEnter" },
    opts = {
      suggestions = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    "saecki/crates.nvim",
    -- version = "*",
    lazy = true,
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function()
      require("crates").setup {
        src = {
          cmp = {
            enabled = true,
          },
        },
      }

      local cmp = require "cmp"
      cmp.setup.buffer { sources = { { name = "crates" }, { name = "buffer" }, { name = "path" } } }
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = { "InsertEnter" },
    dependencies = {
      "nvim-lspconfig",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      -- "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "uga-rosa/cmp-dictionary",
      "hrsh7th/cmp-vsnip",
      "petertriho/cmp-git",
      "zbirenbaum/copilot-cmp",
      -- "saecki/crates.nvim",
    },
    opts = {},
    config = function(_, _)
      local cmp = require "cmp"
      local lspkind = require "lspkind"

      -- General setup.
      cmp.setup {
        completion = {
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = {
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
          },
        },
        sources = {
          { name = "nvim_lsp", group_index = 1 },
          -- { name = "nvim_lsp_signature_help" },  -- Noice.nvim does this already
          { name = "nvim_lua", group_index = 1 },
          {
            name = "path",
            option = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
            group_index = 1,
          },
          { name = "emoji", group_index = 1 },
          { name = "vsnip" },
          { name = "buffer", keyword_length = 3, group_index = 1 },
          { name = "calc", group_index = 1 },
          { name = "dictionary", group_index = 1 },
          { name = "git", group_index = 1 },
          { name = "copilot", group_index = 1 },
        },
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol_text",
            maxwidth = 50,
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              obsidian = "[Obsidian]",
              obsidian_new = "[Obsidian]",
              obsidian_tags = "[Obsidian]",
              git = "[Git]",
            },
            symbol_map = {
              Copilot = "",
            },
          },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }

      -- Throttle completion so it's less annoying.
      local timer = nil
      vim.api.nvim_create_autocmd({ "TextChangedI", "CmdlineChanged" }, {
        pattern = "*",
        callback = function()
          if timer then
            vim.loop.timer_stop(timer)
            timer = nil
          end

          timer = assert(vim.loop.new_timer())
          timer:start(
            300,
            0,
            vim.schedule_wrap(function()
              require("cmp").complete { reason = require("cmp").ContextReason.Auto }
            end)
          )
        end,
      })

      -- source-specific setup

      require("cmp_dictionary").setup {
        dic = {
          ["markdown"] = { vim.fs.normalize "~/.config/nvim/spell/en.utf-8.add", "/usr/share/dict/words" },
        },
      }

      require("cmp_git").setup()

      require("copilot_cmp").setup()
    end,
  },
}
