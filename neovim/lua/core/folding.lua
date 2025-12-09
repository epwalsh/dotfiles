local M = {}

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
  -- Start of function definition (e.g. 'def ...') starts a new fold at level 1.
  elseif line:match "^def [_a-zA-Z].*" then
    return ">1"
  -- Start of method definition (e.g. 'def ...') starts a new fold at level 2.
  elseif line:match "^    def [_a-zA-Z].*" then
    return ">2"
  -- Two blank lines in a row will always end a fold.
  elseif line:len() == 0 and lnum > 1 and (vim.api.nvim_buf_get_lines(0, lnum - 2, lnum - 1, false)[1]):len() == 0 then
    return 0
  elseif line:len() == 0 and (vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)[1]):len() == 0 then
    return 0
  -- Otherwise keep the current fold level.
  else
    return "="
  end
end

return M
