return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      defaults = {},
      pickers = {
        -- find_files = {
        --   theme = "dropdown",
        -- },
        -- grep_string = {
        --   theme = "dropdown",
        -- },
        -- live_grep = {
        --   theme = "dropdown",
        -- },
      },
      extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
        file_browser = {
          hijack_netrw = true,
          no_ignore = false,
          grouped = true,
        },
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      local actions = require "telescope.actions"
      local wk = require "which-key"

      opts.defaults.mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        },
        n = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      }

      -- Setup.
      telescope.setup(opts)

      -- Load extensions.
      telescope.load_extension "file_browser"

      -- Picker mappings.
      local builtin = require "telescope.builtin"

      wk.register {
        ["<leader>f"] = {
          name = "Find",
          f = { builtin.find_files, "Find files" },
          g = { builtin.live_grep, "Find in files" },
          b = { builtin.buffers, "Find buffers" },
          h = { builtin.help_tags, "Find help tags" },
          d = { ":Telescope file_browser<cr>", "Find directories" },
          c = { builtin.commands, "Find commands" },
          t = { ":TodoTelescope keywords=TODO<cr>", "Find TODO comments" },
          j = { builtin.current_buffer_fuzzy_find, "Jump around buffer" },
        },
      }

      wk.register {
        g = {
          name = "LSP go to...",
          i = { builtin.lsp_implementations, "implementations" },
          d = { builtin.lsp_definitions, "definitions" },
          r = { builtin.lsp_references, "references" },
        },
        ["<leader>l"] = {
          name = "LSP",
          d = { builtin.diagnostics, "Show diagnostics" },
          t = { ":TroubleToggle<cr>", "Toggle trouble diagnostics" },
          s = { builtin.lsp_document_symbols, "Document symbols" },
        },
      }
    end,
    init = function()
      -- HACK: When opening a buffer through telescope the folds aren't applied.
      -- See:
      -- * https://github.com/nvim-telescope/telescope.nvim/issues/1277
      -- * https://github.com/tmhedberg/SimpylFold/issues/130#issuecomment-1074049490
      vim.api.nvim_create_autocmd("BufRead", {
        callback = function()
          vim.api.nvim_create_autocmd("BufWinEnter", {
            once = true,
            command = "normal! zx",
          })
        end,
      })

      -- Open file browser on directories (hijacking netrw).
      -- vim.api.nvim_create_autocmd({ "VimEnter" }, {
      --   callback = function(data)
      --     local directory = vim.fn.isdirectory(data.file) == 1
      --     if directory then
      --       vim.cmd ":Telescope file_browser path=%:p:h select_buffer=true"
      --     end
      --   end,
      -- })
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    lazy = true,
    dependencies = { "telescope.nvim", "nvim-lua/plenary.nvim" },
  },

  -- I only use this for testing obsidian.nvim with this picker.
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

  -- I only use this for testing obsidian.nvim with this picker.
  {
    "echasnovski/mini.pick",
    lazy = true,
  },
}
