local autocmd = vim.api.nvim_create_autocmd

autocmd("BufEnter", {
  pattern = "Makefile",
  callback = function()
    local cmp = require("cmp")

    -- Disable 'emoji' completion in Makefiles.
    local sources = {}
    for _, source in pairs(cmp.get_config().sources) do
      if source.name ~= "emoji" then
        table.insert(sources, source)
      end
    end

    cmp.setup.buffer({ sources = sources })
  end,
})
