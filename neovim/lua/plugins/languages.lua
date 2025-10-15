---@diagnostic disable: inject-field

local util = require "core.util"
local log = require "core.log"

return {
  ----------------
  -- Formatting --
  ----------------
  {
    "stevearc/conform.nvim",
    enabled = true,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      -- Define your formatters
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
      },
      -- Set default options
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Set up format-on-save
      -- format_on_save = { timeout_ms = 800 },
      -- Customize formatters
      -- formatters = {
      --   shfmt = {
      --     prepend_args = { "-i", "2" },
      --   },
      -- },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      -- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          if os.getenv "NVIM_FORMAT" ~= "0" then
            require("conform").format { bufnr = args.buf, timeout_ms = 1000 }
          end
        end,
      })
    end,
  },

  ------------
  -- Python --
  ------------
  {
    "Vimjas/vim-python-pep8-indent",
    lazy = true,
    ft = "python",
  },

  {
    "Vigemus/iron.nvim",
    lazy = true,
    ft = { "python", "lua" },
    config = function(_)
      local iron = require "iron.core"
      local view = require "iron.view"
      local common = require "iron.fts.common"

      iron.setup {
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            python = {
              command = function()
                local exit_code, ipython = util.system "which ipython"
                if exit_code ~= 0 or ipython == nil then
                  log.error("Failed to find ipython executable (exit code '%d')", exit_code)
                  return
                end

                return {
                  util.strip_whitespace(ipython),
                  "-i",
                  "--no-confirm-exit",
                  "--no-autoindent",
                  "-c",
                  "'from rich import print, pretty; pretty.install()'",
                }
              end,
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
              -- env = {PYTHON_BASIC_REPL = "1"} --this is needed for python3.13 and up.
            },
          },
          -- set the file type of the newly created repl to ft
          -- bufnr is the buffer id of the REPL and ft is the filetype of the
          -- language being used for the REPL.
          repl_filetype = function(bufnr, ft)
            return ft
            -- or return a string name such as the following
            -- return "iron"
          end,
          -- Send selections to the DAP repl if an nvim-dap session is running.
          dap_integration = true,
          -- How the repl window will be displayed
          -- See below for more information
          -- repl_open_cmd = view.bottom(40),

          -- repl_open_cmd can also be an array-style table so that multiple
          -- repl_open_commands can be given.
          -- When repl_open_cmd is given as a table, the first command given will
          -- be the command that `IronRepl` initially toggles.
          -- Moreover, when repl_open_cmd is a table, each key will automatically
          -- be available as a keymap (see `keymaps` below) with the names
          -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
          -- For example,
          --
          repl_open_cmd = {
            view.split.rightbelow "%25", -- cmd_2: open a repl below
            view.split.vertical.rightbelow "%40", -- cmd_1: open a repl to the right
          },
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          toggle_repl = "<leader>ss", -- toggles the repl open and closed.
          toggle_repl_with_cmd_1 = "<leader>sh",
          toggle_repl_with_cmd_2 = "<leader>sv",
          restart_repl = "<leader>sR", -- calls `IronRestart` to restart the repl
          send_motion = "<leader>sc",
          visual_send = "<space>",
          send_file = "<leader>sf",
          send_line = "<space>",
          send_paragraph = "<leader>sp",
          send_until_cursor = "<leader>su",
          send_mark = "<leader>sm",
          send_code_block = "<leader>sb",
          send_code_block_and_move = "<leader>sn",
          mark_motion = "<leader>mc",
          mark_visual = "<leader>mc",
          remove_mark = "<leader>md",
          cr = "<leader>s<cr>",
          interrupt = "<leader>s<space>",
          exit = "<leader>sq",
          clear = "<leader>cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          -- italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      }

      -- iron also has a list of commands, see :h iron-commands for all available commands
      -- vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<cr>")
      -- vim.keymap.set("n", "<space>rh", "<cmd>IronHide<cr>")

      -- local wk = require "which-key"

      -- wk.add {
      --   { "<leader>ss", "<cmd>IronRepl<cr>", desc = "Start interpreter" },
      -- }
    end,
  },

  {
    "jalvesaq/vimcmdline",
    lazy = true,
    enabled = false,
    ft = { "python", "lua" },
    config = function(_)
      local wk = require "which-key"

      vim.g.cmdline_term_height = 15
      vim.g.cmdline_term_width = 80
      vim.g.cmdline_tmp_dir = "/tmp"
      vim.g.cmdline_outhl = 1
      vim.g.cmdline_app = { python = "ipython -i -c 'from rich import print, pretty; pretty.install()'" }
      -- we override this mapping below, so map here to something we'll probably not use.
      vim.g.cmdline_map_start = "<leader>z"

      local termbuf_filetypes = {
        python = "ipython",
        lua = "lua",
      }

      wk.add {
        {
          "<leader>s",
          function()
            vim.cmd "call cmdline#StartApp()"
            ---@diagnostic disable-next-line: undefined-field
            local ft = vim.opt_local.filetype:get()
            local termbuf_ft = termbuf_filetypes[ft]
            local termbuf_name = vim.api.nvim_get_var("cmdline_termbuf")[ft]
            local termbuf = assert(util.find_buffer_by_name(termbuf_name))
            vim.api.nvim_buf_call(termbuf, function()
              vim.opt_local.filetype = termbuf_ft
            end)
          end,
          desc = "Start interpreter",
        },
      }
    end,
  },

  ---------
  -- Lua --
  ---------
  {
    "ckipp01/stylua-nvim",
    lazy = true,
    ft = "lua",
    build = "cargo install stylua",
  },

  ----------
  -- Fish --
  ----------
  {
    "dag/vim-fish",
    lazy = true,
    ft = "fish",
  },

  ----------
  -- Rust --
  ----------
  {
    "simrat39/rust-tools.nvim",
    lazy = true,
    ft = "rust",
    dependencies = {
      "nvim-lspconfig",
    },
  },
}
