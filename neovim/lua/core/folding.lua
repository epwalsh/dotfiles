local log = require "core.log"

local M = {}

M.open_folds_under_cursor = function()
  local foldlevel = vim.fn.foldlevel(vim.fn.line ".")
  if foldlevel > 0 then
    vim.cmd(string.format("normal %dzo", foldlevel))
  end
end

-- Remove 'search' from 'foldopen' triggers as this circumvents aerial fold management leading to
-- inconsistent fold states.
vim.opt.foldopen:remove "search"
-- Instead remap 'n'/'N' to open folds through aerial's mapping when navigating to search results.
vim.keymap.set("n", "n", function()
  local ok, _ = pcall(vim.cmd, "normal! n")
  if ok then
    M.open_folds_under_cursor()
  else
    local search_pattern = vim.fn.getreg "/"
    log.error("Pattern not found: %s", search_pattern)
  end
end)
vim.keymap.set("n", "N", function()
  local ok, _ = pcall(vim.cmd, "normal! N")
  if ok then
    M.open_folds_under_cursor()
  else
    local search_pattern = vim.fn.getreg "/"
    log.error("Pattern not found: %s", search_pattern)
  end
end)

vim.opt.foldtext = ""

M.treesitter_foldexpr = function()
  local lnum = vim.v.lnum
  -- Get the default Tree-sitter fold level
  local default_fold_level = vim.treesitter.foldexpr(lnum)

  -- Add custom logic based on node types or other criteria
  -- For example, always fold lines containing a specific comment
  -- local line_content = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
  -- if line_content:match("^%s*-- Custom Fold Comment") then
  --   return ">1" -- Force a fold
  -- end

  return default_fold_level
end

M.python_syntax_foldexpr = function()
  local lnum = vim.v.lnum
  local line = vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]
  -- NOTE: see ':help fold-expr' for details on return values.
  -- Start of class definition (e.g. 'class ...') starts a new fold at level 1.
  if line:match "^class [_a-zA-Z].*" then
    return ">1"
  end

  -- Start of function definition (e.g. 'def ...') starts a new fold at level 1.
  if line:match "^def [_a-zA-Z].*" then
    return ">1"
  end

  -- Start of method definition (e.g. 'def ...') starts a new fold at level 2.
  if line:match "^    def [_a-zA-Z].*" then
    return ">2"
  end

  -- TODO: Make blank line before class/function/method also end a fold.

  -- Two blank lines in a row will always end a fold.
  if line:len() == 0 and lnum > 1 and (vim.api.nvim_buf_get_lines(0, lnum - 2, lnum - 1, false)[1]):len() == 0 then
    return 0
  end

  if line:len() == 0 and (vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]):len() == 0 then
    return 0
  end

  -- Otherwise keep the current fold level.
  return "="
end

return M
