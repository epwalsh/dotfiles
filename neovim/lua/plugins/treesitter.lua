return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- lazy = false,
    -- event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
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
      -- HACK: seems to be a bug at the moment
      -- Similar issue to https://www.reddit.com/r/neovim/comments/ymtk2i/treesitter_highlighting_does_not_work/
      local group = vim.api.nvim_create_augroup("treesitter-highlight", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        group = group,
        pattern = "*",
        callback = function()
          vim.cmd ":TSEnable highlight"
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
