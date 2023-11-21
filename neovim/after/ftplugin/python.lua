local Path = require "plenary.path"
local util = require "core.util"
local log = require "core.log"

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"

-- Don't automatically adjust indentation when typing ':'
-- Need to do this in an autocmd. See https://stackoverflow.com/a/37889460/4151392
vim.opt_local.indentkeys:remove { "<:>" }
vim.opt_local.indentkeys:append { "=else:" }

-- Configure auto formatting using isort and black.
-- Adapted from stylua-nvim:
-- https://github.com/ckipp01/stylua-nvim/blob/main/lua/stylua-nvim.lua

local function format_buffer()
  if os.getenv "NVIM_FORMAT" == "0" then
    log.info "Skipping formatting since NVIM_FORMAT=0"
    return
  end

  local tmp_dir = "/tmp/nvim/format"
  Path:new(tmp_dir):mkdir { exists_ok = true, parents = true }

  local isort_command = "isort --stdout --quiet -"
  local black_command = "black --quiet -"
  local bufnr = vim.fn.bufnr "%"

  local input = util.buf_get_full_text(bufnr)
  local output = input
  for _, command in pairs { isort_command, black_command } do
    local err_file = tmp_dir .. "/log.err"
    output = vim.fn.system(command .. " 2>" .. err_file, output)
    if vim.fn.empty(output) ~= 0 then
      log.error("Error running format command '" .. command .. "'. See logs at " .. err_file)
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
    pcall(vim.cmd.loadview)
  end,
})
