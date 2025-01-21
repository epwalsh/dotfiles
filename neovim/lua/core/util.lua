local M = {}

---@enum core.OS
M.OS = {
  Linux = "Linux",
  Wsl = "Wsl",
  Windows = "Windows",
  Darwin = "Darwin",
}

--- Get the running operating system.
--- Reference https://vi.stackexchange.com/a/2577/33116
---@return core.OS
M.get_os = function()
  if vim.fn.has "win32" == 1 then
    return M.OS.Windows
  end

  local this_os = tostring(io.popen("uname"):read())
  if this_os == "Linux" and vim.fn.readfile("/proc/version")[1]:lower():match "microsoft" then
    this_os = M.OS.Wsl
  end
  return this_os
end

--- Insert text at current cursor position.
---@param text string
M.insert_text = function(text)
  local curpos = vim.fn.getcurpos()
  local line_num, line_col = curpos[2], curpos[3]

  -- Convert text to lines table so we can handle multi-line strings.
  local lines = {}
  for line in text:gmatch "[^\r\n]+" do
    lines[#lines + 1] = line
  end

  vim.api.nvim_buf_set_text(0, line_num - 1, line_col, line_num - 1, line_col, lines)
end

---@param bufnr integer
---
---@return string
M.buf_get_full_text = function(bufnr)
  local text = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, true), "\n")
  if vim.api.nvim_get_option_value("eol", { buf = bufnr }) then
    text = text .. "\n"
  end
  return text
end

---@return string
M.get_visual_selection = function()
  -- This is the best way I've found so far for getting the current visual selection,
  -- which seems like a total hack.
  local a_orig = vim.fn.getreg "a"
  vim.cmd [[silent! normal! "aygv]]

  local text = vim.fn.getreg "a"
  assert(type(text) == "string")

  -- Reset register.
  vim.fn.setreg("a", a_orig)

  return text
end

--- Run a system command through 'vim.fn.system'. Returns the exit code and output.
---
---@param cmd string|string[]
---
---@return integer
---@return string|?
M.system = function(cmd)
  local output = vim.fn.system(cmd)
  return vim.api.nvim_get_vvar "shell_error", output
end

--- Strip whitespace from the ends of a string.
---@param str string
---
---@return string
M.strip_whitespace = function(str)
  return M.rstrip_whitespace(M.lstrip_whitespace(str))
end

--- Strip whitespace from the right end of a string.
---@param str string
---
---@return string
M.rstrip_whitespace = function(str)
  str = string.gsub(str, "%s+$", "")
  return str
end

--- Strip whitespace from the left end of a string.
---
---@param str string
---@param limit integer|?
---
---@return string
M.lstrip_whitespace = function(str, limit)
  if limit ~= nil then
    local num_found = 0
    while num_found < limit do
      str = string.gsub(str, "^%s", "")
      num_found = num_found + 1
    end
  else
    str = string.gsub(str, "^%s+", "")
  end
  return str
end

--- Get a buffer number by name.
---
---@param name string
---
---@return integer|?
M.find_buffer_by_name = function(name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name == name then
      return buf
    end
  end
  return nil
end

---@class core.PaperMetadata
---
---@field corpus_id string|integer
---@field title string
---@field url string
---@field tldr { text: string }

---@param corpus_id integer|string
---
---@return core.PaperMetadata
M.get_paper_metadata = function(corpus_id)
  local curl = require "plenary.curl"

  local response = curl.get {
    url = string.format("https://api.semanticscholar.org/graph/v1/paper/CorpusId:%s?fields=tldr,title,url", corpus_id),
    -- NOTE: the curl wrapper from plenary mangles the header keys, but the S2 API expects the
    -- exact key 'x_api_key'.
    raw = { "-H", "Accept: application/json", "-H", string.format("x-api-key: %s", assert(os.getenv "S2_API_KEY")) },
    -- headers = {
    --   accept = "application/json",
    --   x_api_key = assert(os.getenv "S2_API_KEY"),
    -- },
  }
  assert(response.status == 200, string.format("Received status code %s", response.status))
  local data = vim.json.decode(response.body)
  data.corpus_id = corpus_id
  return data
end

---@param note obsidian.Note
---@param data core.PaperMetadata
M.update_note_with_paper_metadata = function(note, data)
  note:add_tag "paper"
  note:add_alias(data.title .. " (paper)")
  note:add_field("corpus_id", data.corpus_id)
  note:add_field("url", data.url)
  note:add_field("tldr", data.tldr.text)
end

M.disable_autopairs = function()
  require("nvim-autopairs").disable()
end

M.enable_autopairs = function()
  require("nvim-autopairs").enable()
end

M.toggle_autopairs = function()
  require("nvim-autopairs").toggle()
end

local INPUT_CANCELLED = "~~~INPUT-CANCELLED~~~"

--- Prompt user for an input. Returns nil if canceled, otherwise a string (possibly empty).
---
---@param prompt string
---@param opts { completion: string|?, default: string|? }|?
---
---@return string|?
M.input = function(prompt, opts)
  opts = opts or {}

  if not vim.endswith(prompt, " ") then
    prompt = prompt .. " "
  end

  local input = M.strip_whitespace(
    vim.fn.input { prompt = prompt, completion = opts.completion, default = opts.default, cancelreturn = INPUT_CANCELLED }
  )

  if input ~= INPUT_CANCELLED then
    return input
  else
    return nil
  end
end

return M
