return {
  --------------
  -- NvimTree --
  --------------
  {
    "nvim-tree/nvim-tree.lua",
    lazy = true,
    cmd = { "NvimTreeToggle" },
    keys = { "<F2>" },
    opts = {
      hijack_netrw = true, -- this interferes with telescope file browser
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
      view = {
        width = 24,
      },
      actions = {
        change_dir = {
          enable = false,
        },
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Custom
        vim.keymap.set("n", "h", api.tree.toggle_help, opts "Help")
        vim.keymap.set("n", "?", api.tree.toggle_help, opts "Help")
        vim.keymap.set("n", "s", api.node.open.vertical, opts "Open: Vertical Split")
        vim.keymap.set("n", "i", api.node.open.horizontal, opts "Open: Horizontal Split")

        -- Defaults
        vim.keymap.set("n", "<C-]>", api.tree.change_root_to_node, opts "CD")
        vim.keymap.set("n", "<C-e>", api.node.open.replace_tree_buffer, opts "Open: In Place")
        vim.keymap.set("n", "<C-k>", api.node.show_info_popup, opts "Info")
        vim.keymap.set("n", "<C-r>", api.fs.rename_sub, opts "Rename: Omit Filename")
        vim.keymap.set("n", "<C-t>", api.node.open.tab, opts "Open: New Tab")
        vim.keymap.set("n", "<BS>", api.node.navigate.parent_close, opts "Close Directory")
        vim.keymap.set("n", "<CR>", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "<Tab>", api.node.open.preview, opts "Open Preview")
        vim.keymap.set("n", ">", api.node.navigate.sibling.next, opts "Next Sibling")
        vim.keymap.set("n", "<", api.node.navigate.sibling.prev, opts "Previous Sibling")
        vim.keymap.set("n", ".", api.node.run.cmd, opts "Run Command")
        vim.keymap.set("n", "-", api.tree.change_root_to_parent, opts "Up")
        vim.keymap.set("n", "a", api.fs.create, opts "Create")
        vim.keymap.set("n", "bmv", api.marks.bulk.move, opts "Move Bookmarked")
        vim.keymap.set("n", "B", api.tree.toggle_no_buffer_filter, opts "Toggle No Buffer")
        vim.keymap.set("n", "c", api.fs.copy.node, opts "Copy")
        vim.keymap.set("n", "C", api.tree.toggle_git_clean_filter, opts "Toggle Git Clean")
        vim.keymap.set("n", "[c", api.node.navigate.git.prev, opts "Prev Git")
        vim.keymap.set("n", "]c", api.node.navigate.git.next, opts "Next Git")
        vim.keymap.set("n", "d", api.fs.remove, opts "Delete")
        vim.keymap.set("n", "D", api.fs.trash, opts "Trash")
        vim.keymap.set("n", "E", api.tree.expand_all, opts "Expand All")
        vim.keymap.set("n", "e", api.fs.rename_basename, opts "Rename: Basename")
        vim.keymap.set("n", "]e", api.node.navigate.diagnostics.next, opts "Next Diagnostic")
        vim.keymap.set("n", "[e", api.node.navigate.diagnostics.prev, opts "Prev Diagnostic")
        vim.keymap.set("n", "F", api.live_filter.clear, opts "Clean Filter")
        vim.keymap.set("n", "f", api.live_filter.start, opts "Filter")
        vim.keymap.set("n", "gy", api.fs.copy.absolute_path, opts "Copy Absolute Path")
        vim.keymap.set("n", "H", api.tree.toggle_hidden_filter, opts "Toggle Dotfiles")
        vim.keymap.set("n", "I", api.tree.toggle_gitignore_filter, opts "Toggle Git Ignore")
        vim.keymap.set("n", "J", api.node.navigate.sibling.last, opts "Last Sibling")
        vim.keymap.set("n", "K", api.node.navigate.sibling.first, opts "First Sibling")
        vim.keymap.set("n", "m", api.marks.toggle, opts "Toggle Bookmark")
        vim.keymap.set("n", "o", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "O", api.node.open.no_window_picker, opts "Open: No Window Picker")
        vim.keymap.set("n", "p", api.fs.paste, opts "Paste")
        vim.keymap.set("n", "P", api.node.navigate.parent, opts "Parent Directory")
        vim.keymap.set("n", "q", api.tree.close, opts "Close")
        vim.keymap.set("n", "r", api.fs.rename, opts "Rename")
        vim.keymap.set("n", "R", api.tree.reload, opts "Refresh")
        vim.keymap.set("n", "S", api.tree.search_node, opts "Search")
        vim.keymap.set("n", "U", api.tree.toggle_custom_filter, opts "Toggle Hidden")
        vim.keymap.set("n", "W", api.tree.collapse_all, opts "Collapse")
        vim.keymap.set("n", "x", api.fs.cut, opts "Cut")
        vim.keymap.set("n", "y", api.fs.copy.filename, opts "Copy Name")
        vim.keymap.set("n", "Y", api.fs.copy.relative_path, opts "Copy Relative Path")
        vim.keymap.set("n", "<2-LeftMouse>", api.node.open.edit, opts "Open")
        vim.keymap.set("n", "<2-RightMouse>", api.tree.change_root_to_node, opts "CD")
      end,
    },
    init = function()
      vim.keymap.set("n", "<F2>", require("nvim-tree.api").tree.toggle)

      -- Uncomment this to open NvimTree on directories.
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if directory then
            pcall(require("nvim-tree.api").tree.close)
            require("nvim-tree.api").tree.open { path = data.file }
          end
        end,
      })
    end,
  },

  ------------
  -- Aerial --
  ------------
  {
    "stevearc/aerial.nvim",
    lazy = true,
    cmd = { "AerialToggle" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-web-devicons",
    },
    opts = {},
    -- Optional dependencies
    init = function()
      local wk = require "which-key"

      wk.register {
        ["<leader>"] = {
          name = "Aerial",
          a = { "<cmd>AerialToggle<CR>", "Aerial" },
        },
      }
    end,
  },

  ---------------
  -- Telescope --
  ---------------
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
          br = { ":Telescope file_browser<cr>", "Browse files" },
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
}
