local cmp = require('cmp')

-- Disable 'emoji' completion in Makefiles.
local sources = cmp.get_config().sources
for i = #sources, 1, -1 do
  if sources[i].name == 'emoji' then
    table.remove(sources, i)
  end
end

cmp.setup.buffer({ sources = sources })
