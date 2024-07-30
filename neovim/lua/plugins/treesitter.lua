return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- lazy = false,
    -- event = { "BufReadPre", "BufNewFile" },
    version = "*",
    build = function()
      -- Set environment variables for building treesitter markdown extensions.
      -- TODO: tree-sitter doesn't seem to respect these.
      vim.env.EXTENSION_WIKI_LINK = "1"
      vim.env.EXTENSION_TAGS = "1"

      vim.cmd ":TSUpdate"
    end,
    config = function(opts)
      -- NOTE: currently we have to build markdown parsers locally since tree-sitter doesn't have
      -- a good way to do conditional compiles (needed to get the wiki link and tags features).
      -- To compile these, go to ~/github.com/tree-sitter-grammars/tree-sitter-markdown
      -- and run `EXTENSION_WIKI_LINK=1 EXTENSION_TAGS=1 npm run build`.
      -- Then in nvim, `TSInstall markdown markdown_inline`.
      -- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      -- parser_config.markdown = {
      --   install_info = {
      --     url = "~/github.com/tree-sitter-grammars/tree-sitter-markdown/tree-sitter-markdown",
      --     files = { "src/scanner.c", "src/parser.c" },
      --     branch = "main",
      --     generate_requires_npm = false,
      --     requires_generate_from_grammer = false,
      --   },
      --   filetype = "markdown",
      -- }

      -- parser_config.markdown_inline = {
      --   install_info = {
      --     url = "~/github.com/tree-sitter-grammars/tree-sitter-markdown/tree-sitter-markdown-inline",
      --     files = { "src/scanner.c", "src/parser.c" },
      --     branch = "main",
      --     generate_requires_npm = false,
      --     requires_generate_from_grammer = false,
      --   },
      --   filetype = "markdown",
      -- }

      require("nvim-treesitter").setup(opts)
    end,
    opts = {
      -- A list of parser names, or "all"
      ensure_installed = {
        "python",
        "lua",
        "rust",
        "go",
        "markdown",
        "markdown_inline",
        "jsonnet",
        "yaml",
        "make",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      auto_install = true,

      -- List of parsers to ignore installing (for "all")
      -- ignore_install = { "javascript" },

      -- Indentation via treesitter is experimental
      indent = {
        enable = false,
        -- disable = { "python" },
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,

        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
        -- the name of the parser)
        -- list of language that will be disabled
        -- disable = { "markdown", "markdown_inline" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        -- additional_vim_regex_highlighting = { "markdown" },
      },
    },
    init = function()
      local group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = group,
        pattern = "*",
        callback = function()
          -- HACK: seems to be a bug at the moment
          -- Similar issue to https://www.reddit.com/r/neovim/comments/ymtk2i/treesitter_highlighting_does_not_work/
          vim.cmd ":TSEnable highlight"

          -- Enable strikethrough for markdown.
          vim.api.nvim_set_hl(0, "@text.strike.markdown_inline", { link = "htmlStrike" })
        end,
      })
    end,
  },

  {
    "nvim-treesitter/playground",
    lazy = true,
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  },
}
