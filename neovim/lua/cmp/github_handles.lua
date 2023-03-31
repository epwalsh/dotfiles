-- Custom nvim-cmp source for GitHub handles.
-- Adapted from https://github.com/wincent/wincent/blob/2d926177773f72f4bf3d87b87ac8535ad45341ad/aspects/nvim/files/.config/nvim/lua/wincent/cmp/handles.lua

local handles = {
  AkshitaB = "Akshita Bhagia",
  dirkgr = "Dirk Groeneveld",
  schmmd = "Michael Schmitz",
  jonborchardt = "Jon Borchardt",
  codeviking = "Sam Skjonsberg",
}

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_trigger_characters = function()
  return { "@" }
end

source.get_keyword_pattern = function()
  -- Add dot to existing keyword characters (\k).
  return [[\%(\k\|\.\)\+]]
end

source.complete = function(_, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset - 1)
  local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

  if vim.startswith(input, "@") and (prefix == "@" or vim.endswith(prefix, " @")) then
    local items = {}
    for handle, name in pairs(handles) do
      table.insert(items, {
        filterText = handle .. " " .. name,
        label = name,
        textEdit = {
          newText = "@" .. handle,
          range = {
            start = {
              line = request.context.cursor.row - 1,
              character = request.context.cursor.col - 1 - #input,
            },
            ["end"] = {
              line = request.context.cursor.row - 1,
              character = request.context.cursor.col - 1,
            },
          },
        },
      })
    end
    callback {
      items = items,
      isIncomplete = true,
    }
  else
    callback { isIncomplete = true }
  end
end

return source
