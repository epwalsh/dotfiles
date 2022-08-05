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
  local bufnr = vim.fn.bufnr("%")

  local input = buf_get_full_text(bufnr)
  local output = input
  for _, command in pairs({ isort_command, black_command }) do
    output = vim.fn.system(command, output)
    if vim.fn.empty(output) ~= 0 then
      -- TODO: warn user about errors?
      return
    end
  end

  if output ~= input then
    local new_lines = vim.fn.split(output, "\n")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
  end
end

local group = vim.api.nvim_create_augroup("python_format", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = "*.py",
  callback = format_buffer,
})
