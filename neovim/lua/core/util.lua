local M = {}

---@enum OS
M.OS = {
  Linux = "Linux",
  Wsl = "Wsl",
  Windows = "Windows",
  Darwin = "Darwin",
}

--- Get the running operating system.
--- Reference https://vi.stackexchange.com/a/2577/33116
---@return OS
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
  local indent = string.rep(" ", line_col)

  -- Convert text to lines table so we can handle multi-line strings.
  local lines = {}
  for line in text:gmatch "[^\r\n]+" do
    lines[#lines + 1] = line
  end

  for line_index, line in pairs(lines) do
    local current_line_num = line_num + line_index - 1
    local current_line = vim.fn.getline(current_line_num)
    assert(type(current_line) == "string")

    -- Since there's no column 0, remove extra space when current line is blank.
    if current_line == "" then
      indent = indent:sub(1, -2)
    end

    local pre_txt = current_line:sub(1, line_col)
    local post_txt = current_line:sub(line_col + 1, -1)
    local inserted_txt = pre_txt .. line .. post_txt

    vim.fn.setline(current_line_num, inserted_txt)

    -- Create new line so inserted_txt doesn't replace next lines
    if line_index ~= #lines then
      vim.fn.append(current_line_num, indent)
    end
  end
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
return M
