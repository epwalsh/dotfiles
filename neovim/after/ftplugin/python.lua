local wk = require "which-key"
local util = require "core.util"
local log = require "core.log"

-- # NOTE: folds managed by aerial.nvim.
-- vim.opt_local.foldmethod = "expr"
-- vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.opt_local.foldexpr = 'v:lua.require("core.folding").treesitter_foldexpr()'
-- vim.opt_local.foldexpr = 'v:lua.require("core.folding").python_syntax_foldexpr()'
-- vim.opt_local.foldtext = ""
-- vim.opt_local.foldlevelstart = 1

-- Customize which queries are used for folding with treesitter.
-- See https://github.com/nvim-treesitter/nvim-treesitter/discussions/1513#discussioncomment-971396
if require("nvim-treesitter.parsers").has_parser "python" then
  local folds_query = [[
  [
    (function_definition)
    (class_definition)

    (string)

    (import_from_statement)
  ] @fold
  ]]
  require("vim.treesitter.query").set("python", "folds", folds_query)
end

-- Don't automatically adjust indentation when typing ':'
-- Need to do this in an autocmd. See https://stackoverflow.com/a/37889460/4151392
vim.opt_local.indentkeys:remove { "<:>" }
vim.opt_local.indentkeys:append { "=else:" }

local group = vim.api.nvim_create_augroup("python", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = group,
  pattern = "*.py",
  callback = function()
    -- Update folds on save.
    vim.cmd "normal! zx"
    vim.cmd "normal! zx" -- note: sometimes need to call a 2nd time.
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = group,
  pattern = "*.py",
  callback = function()
    wk.add {
      { "<leader>p", group = "Python" },
      {
        "<leader>pd",
        function()
          local python_version = util.get_python_version()
          local text = vim.fn.expand "<cword>"
          if text and text ~= "" then
            local url = string.format(
              "https://docs.python.org/%s.%s/search.html?q=%s",
              python_version[1],
              python_version[2],
              text
            )
            vim.ui.open(url)
          else
            log.warn "No name under cursor"
          end
        end,
        desc = "Look up name on docs.python.org",
      },
      {
        "<leader>pt",
        function()
          local bufname = vim.api.nvim_buf_get_name(0)
          vim.cmd("AsyncRun pytest -vv " .. bufname)
        end,
        desc = "Run pytest on the current file",
      },
    }
  end,
})
