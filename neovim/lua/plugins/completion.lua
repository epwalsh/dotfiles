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
    "hrsh7th/nvim-cmp",
    lazy = true,
    event = { "InsertEnter" },
    dependencies = {
      "nvim-lspconfig",
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-emoji",
      "uga-rosa/cmp-dictionary",
      "hrsh7th/cmp-vsnip",
      "petertriho/cmp-git",
      "zbirenbaum/copilot-cmp",
    },
    opts = {},
    config = function(_, _)
      local cmp = require "cmp"
      local lspkind = require "lspkind"

      -- General setup.
      cmp.setup {
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
          { name = "nvim_lsp" },
          -- { name = "nvim_lsp_signature_help" },  -- Noice.nvim does this already
          { name = "nvim_lua" },
          {
            name = "path",
            option = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          { name = "emoji" },
          { name = "vsnip" },
          { name = "buffer", keyword_length = 3 },
          { name = "calc" },
          { name = "dictionary" },
          { name = "git" },
          { name = "copilot" },
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

      -- Filetype specific setup.

      cmp.setup.filetype("markdown", {
        sources = cmp.config.sources {
          -- { name = "nvim_lsp" },
          -- { name = "nvim_lsp_signature_help" },
          { name = "emoji" },
          { name = "buffer", keyword_length = 3 },
          {
            name = "path",
            option = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          { name = "vsnip" },
          { name = "calc" },
          { name = "dictionary", keyword_length = 3 },
        },
      })

      cmp.setup.filetype("yaml", {
        sources = cmp.config.sources {
          { name = "buffer", keyword_length = 3 },
          {
            name = "path",
            option = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          { name = "calc" },
          { name = "emoji", option = { insert = true } },
          { name = "dictionary", keyword_length = 3 },
        },
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
