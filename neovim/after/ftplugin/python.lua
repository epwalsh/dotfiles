vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldnestmax = 2
vim.opt_local.spell = true

-- Don't automatically adjust indentation when typing ':'
-- Need to do this in an autocmd. See https://stackoverflow.com/a/37889460/4151392
vim.opt_local.indentkeys:remove { "<:>" }
vim.opt_local.indentkeys:append { "=else:" }

-- Configure auto formatting using isort and black.
-- Adapted from stylua-nvim:
-- https://github.com/ckipp01/stylua-nvim/blob/main/lua/stylua-nvim.lua

local function buf_get_full_text(bufnr)
  local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true), "\n")
  if vim.api.nvim_buf_get_option(bufnr, "eol") then
    text = text .. "\n"
  end
  return text
end

local function format_buffer()
  local isort_command = "isort --stdout --quiet - 2>/dev/null"
  local black_command = "black --quiet - 2>/dev/null"
  local bufnr = vim.fn.bufnr "%"

  local input = buf_get_full_text(bufnr)
  local output = input
  for _, command in pairs { isort_command, black_command } do
    output = vim.fn.system(command, output)
    if vim.fn.empty(output) ~= 0 then
      -- TODO: warn user about errors?
      return
    end
  end

  vim.cmd "mkview"
  if output ~= input then
    -- Save current view. We restore this on `BufWritePost` (see below).
    -- Idea taken from https://github.com/nvim-treesitter/nvim-treesitter/issues/1424#issuecomment-909181939
    local new_lines = vim.fn.split(output, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
    vim.opt.foldmethod = vim.opt.foldmethod
  end
end

local group = vim.api.nvim_create_augroup("python_format", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = "*.py",
  callback = format_buffer,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = group,
  pattern = "*.py",
  callback = function()
    vim.cmd "edit"
    pcall(vim.cmd, "loadview")
  end,
})
