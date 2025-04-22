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

      local builtin = require "telescope.builtin"

      -- Picker mappings.
      wk.add {
        { "<leader>f", group = "Find" },
        { "<leader>ff", builtin.find_files, desc = "Find files" },
        { "<leader>fg", builtin.live_grep, desc = "Find in files" },
        { "<leader>fb", builtin.buffers, desc = "Find buffers" },
        { "<leader>fh", builtin.help_tags, desc = "Find help tags" },
        { "<leader>fd", ":Telescope file_browser<cr>", desc = "Find directories" },
        { "<leader>fc", builtin.commands, desc = "Find commands" },
        { "<leader>ft", ":TodoTelescope keywords=TODO<cr>", desc = "Find TODO comments" },
        { "<leader>fj", builtin.current_buffer_fuzzy_find, desc = "Jump around buffer" },
        {
          "<leader>fp",
          function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local dirname = vim.fs.dirname(bufname)
            telescope.extensions.file_browser.file_browser { path = dirname }
            -- builtin.find_files { cwd = dirname }
          end,
          desc = "Browse files in the buffer's parent directory",
        },
      }

      wk.add {
        { "g", group = "LSP go to..." },
        { "gi", builtin.lsp_implementations, desc = "implementations" },
        { "gd", builtin.lsp_definitions, desc = "definitions" },
        { "gr", builtin.lsp_references, desc = "references" },
        { "<leader>l", group = "LSP" },
        { "<leader>ld", builtin.diagnostics, desc = "Show diagnostics" },
        { "<leader>ls", builtin.lsp_document_symbols, desc = "Document symbols" },
        { "<leader>lt", ":Trouble diagnostics toggle<cr>", desc = "Toggle trouble diagnostics" },
        { "<leader>lb", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "Toggle trouble bugger diagnostics" },
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
