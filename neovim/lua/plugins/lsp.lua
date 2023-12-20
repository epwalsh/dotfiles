return {
  ---------------
  -- lspconfig --
  ---------------
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = {
      library = {
        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
        -- these settings will be used for your Neovim config directory
        runtime = true, -- runtime path
        types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
        plugins = true, -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
      },
      setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
      -- for your Neovim config directory, the config.library settings will be used as is
      -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
      -- for any other directory, config.library.enabled will be set to false
      ---@diagnostic disable-next-line: unused-local
      override = function(root_dir, library)
        library.enabled = true
        library.plugins = true
      end,
      -- With lspconfig, Neodev will automatically setup your lua-language-server
      -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
      -- in your lsp start options
      lspconfig = true,
      -- much faster, but needs a recent build of lua-language-server
      -- needs lua-language-server >= 3.6.0
      pathStrict = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "trouble.nvim",
      "neodev.nvim",
    },
    opts = {},
    config = function()
      -- General LSP settings
      vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
      vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- delay update diagnostics
        update_in_insert = false,
      })

      -- Noice handles these
      -- local border = {
      --   { "╭", "FloatBorder" },
      --   { "─", "FloatBorder" },
      --   { "╮", "FloatBorder" },
      --   { "│", "FloatBorder" },
      --   { "╯", "FloatBorder" },
      --   { "─", "FloatBorder" },
      --   { "╰", "FloatBorder" },
      --   { "│", "FloatBorder" },
      -- }
      -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
      -- vim.lsp.handlers["textDocument/signatureHelp"] =
      --   vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

      -- Rust.
      require("lspconfig").rust_analyzer.setup {
        -- on_attach = function(client)
        --   require("illuminate").on_attach(client)
        -- end,
        settings = {
          format = {
            enable = true,
          },
        },
      }

      vim.cmd [[autocmd BufWritePre *.rs lua vim.lsp.buf.format()]]

      -- Go.
      require("lspconfig").gopls.setup {
        -- on_attach = function(client)
        --   require("illuminate").on_attach(client)
        -- end,
      }

      -- Lua.
      require("lspconfig").lua_ls.setup {
        -- on_attach = function(client)
        --   require("illuminate").on_attach(client)
        -- end,
        commands = {
          Format = {
            function()
              require("stylua-nvim").format_file()
            end,
          },
        },
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            -- workspace = {
            --   -- Make the server aware of Neovim runtime files
            --   library = vim.api.nvim_get_runtime_file("", true),
            --   checkThirdParty = false,
            -- },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
            format = {
              enable = true,
              defaultConfig = {
                indent_style = "space",
                indent_size = "2",
              },
            },
          },
        },
      }

      -- Automatic formatting.
      vim.cmd [[autocmd BufWritePre *.lua :Format]]

      -- Python.
      --
      -- NOTE: We're using a different language servers here.
      --
      -- Jedi has great LS capabilities, but only checks for syntax errors, so it
      -- doesn't help with linting and type-checking.
      --
      -- On the other hand, Pyright is great for linting and type-checking, but its
      -- other LS capabilities are not great, so we disable Pyright as a completion
      -- provider to avoid duplicate suggestions from nvim-cmp.
      --
      -- NOTE: To see which capabilities a LS has, run
      -- :lua =vim.lsp.get_active_clients()[1].server_capabilities
      -- (change the index from '1' to whatever if you have multiple)
      require("lspconfig")["jedi_language_server"].setup {
        on_attach = function(client, _)
          client.server_capabilities.renameProvider = true
          -- Jedi works best as the hover provider.
          client.server_capabilities.hoverProvider = true
        end,
      }

      if os.getenv "NVIM_PYRIGHT" ~= "0" then
        require("lspconfig")["pyright"].setup {
          on_attach = function(client, _)
            -- Renaming doesn't work properly unless we only have a single
            -- rename provider, so we disable it for pyright.
            -- See https://github.com/neovim/neovim/issues/15899
            client.server_capabilities.renameProvider = false
            client.server_capabilities.completionProvider = false
            -- Jedi works best as the hover provider.
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.signatureHelpProvider = false
          end,
        }
      end

      require("lspconfig")["ruff_lsp"].setup {
        on_attach = function(client, _)
          client.server_capabilities.renameProvider = false
          -- Jedi works best as the hover provider.
          client.server_capabilities.hoverProvider = false
        end,
      }

      -- Markdown.
      -- require("lspconfig").marksman.setup {}

      -- Bash.
      require("lspconfig").bashls.setup {}

      --------------
      -- Mappings --
      --------------
      local wk = require "which-key"

      wk.register {
        g = {
          name = "LSP go to...",
          i = { vim.lsp.buf.implementation, "Go to implementation" },
          d = { vim.lsp.buf.definition, "Go to definition" },
          r = { vim.lsp.buf.references, "Go to references" },
        },
        K = { vim.lsp.buf.hover, "LSP hover" },
        ["<c-k>"] = { vim.lsp.buf.signature_help, "LSP signature help" },
      }
    end,
  },

  -----------
  -- Mason --
  -----------
  {
    "williamboman/mason.nvim",
    lazy = true,
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "pyright",
        "rust-analyzer",
        "jedi-language-server",
        "ruff-lsp",
        "shellcheck",
        "bash-language-server",
        "stylua",
        -- "marksman",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -------------
  -- Trouble --
  -------------
  {
    "folke/trouble.nvim",
    lazy = true,
    cmd = "Trouble",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
    },
    opts = {},
  },
}
