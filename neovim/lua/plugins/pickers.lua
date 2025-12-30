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
        { "<leader>f", group = "[f]ind..." },
        { "<leader>ff", builtin.find_files, desc = "[f]iles" },
        { "<leader>fg", builtin.live_grep, desc = "[g]rep" },
        { "<leader>fg", builtin.grep_string, desc = "[g]rep", mode = "v" },
        { "<leader>fb", builtin.buffers, desc = "[b]uffers" },
        { "<leader>fh", builtin.help_tags, desc = "[h]elp tags" },
        { "<leader>fc", builtin.commands, desc = "[c]ommands" },
        { "<leader>ft", ":TodoTelescope keywords=TODO<cr>", desc = "[t]odo comments" },
        { "<leader>fj", builtin.current_buffer_fuzzy_find, desc = "[j]ump in buffer" },
        { "<leader>fd", group = "in current [d]irectory..." },
        {
          "<leader>fdg",
          function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local dirname = vim.fs.dirname(bufname)
            builtin.live_grep { cwd = dirname }
          end,
          desc = "[g]rep",
        },
        {
          "<leader>fdg",
          function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local dirname = vim.fs.dirname(bufname)
            builtin.grep_string { cwd = dirname }
          end,
          desc = "[g]rep",
          mode = "v",
        },
        {
          "<leader>fdf",
          function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local dirname = vim.fs.dirname(bufname)
            telescope.extensions.file_browser.file_browser { path = dirname }
            -- builtin.find_files { cwd = dirname }
          end,
          desc = "[f]iles",
        },
      }

      -- These conflict or are redundant with some lsp mappings set below.
      vim.cmd "unmap gra"
      vim.cmd "unmap gri"
      vim.cmd "unmap grn"
      vim.cmd "unmap grt"
      vim.cmd "unmap grr"

      wk.add {
        { "g", group = "[g]o to..." },
        { "gi", builtin.lsp_implementations, desc = "[i]mplementations" },
        {
          "gr",
          function()
            builtin.lsp_references()
          end,
          desc = "[r]eferences",
        },
        { "gd", group = "[d]efinitions..." },
        {
          "gde",
          function()
            builtin.lsp_definitions { reuse_win = true }
          end,
          desc = "open with [e]dit",
        },
        {
          "gdv",
          function()
            builtin.lsp_definitions { reuse_win = true, jump_type = "vsplit" }
          end,
          desc = "open with [v]split",
        },
        { "<leader>l", group = "[l]sp..." },
        { "<leader>ld", builtin.diagnostics, desc = "[d]iagnostics" },
        { "<leader>ls", builtin.lsp_document_symbols, desc = "document [s]ymbols" },
        { "<leader>lt", ":Trouble diagnostics toggle<cr>", desc = "[t]rouble diagnostics" },
        { "<leader>lb", ":Trouble diagnostics toggle filter.buf=0<cr>", desc = "[b]uffer diagnostics" },
      }
    end,
    init = function()
      -- HACK: When opening a buffer through telescope the folds aren't applied.
      -- See:
      -- * https://github.com/nvim-telescope/telescope.nvim/issues/1277
      -- * https://github.com/tmhedberg/SimpylFold/issues/130#issuecomment-1074049490
      -- vim.api.nvim_create_autocmd("BufRead", {
      --   callback = function()
      --     vim.api.nvim_create_autocmd("BufWinEnter", {
      --       once = true,
      --       command = "normal! zx",
      --     })
      --   end,
      -- })

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
