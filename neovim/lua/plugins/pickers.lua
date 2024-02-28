return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
          i = {
            -- map actions.which_key to <C-h> (default: <C-/>)
            -- actions.which_key shows the mappings for your picker,
            -- e.g. git_{create, delete, ...}_branch for the git_branches picker
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
      },
      extensions = {
        -- Your extension configuration goes here:
        -- extension_name = {
        --   extension_config_key = value,
        -- }
        -- please take a look at the readme of the extension you want to configure
        file_browser = {
          hijack_netrw = false,
        },
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"
      local wk = require "which-key"

      -- Setup.
      telescope.setup(opts)

      -- Load extensions.
      telescope.load_extension "file_browser"

      -- Picker mappings.
      local builtin = require "telescope.builtin"
      wk.register {
        ["<leader>"] = {
          name = "Find",
          ff = { builtin.find_files, "Find files" },
          fg = { builtin.live_grep, "Find in files" },
          fb = { builtin.buffers, "Find buffers" },
          fh = { builtin.help_tags, "Find help tags" },
          fd = { ":Telescope file_browser<cr>", "Find directories" },
          fc = { builtin.commands, "Find commands" },
          ft = { ":TodoTelescope keywords=TODO<cr>", "Find TODO comments" },
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
