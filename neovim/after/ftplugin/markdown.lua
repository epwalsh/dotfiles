---@diagnostic disable: inject-field

local paste_img = require("core.img_paste").paste_img

vim.g.markdown_fenced_languages = { "html", "python", "bash=sh", "rust" }
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.list = false
vim.opt_local.omnifunc = ""
vim.opt_local.conceallevel = 2

vim.api.nvim_create_user_command("ImgPaste", function(data)
  paste_img(data.args, "assets/imgs", function(path)
    return string.format("![%s](%s)", path.filename, tostring(path))
  end)
end, { nargs = "?", complete = "file" })

-- Start an ipython session
vim.keymap.set("n", "<leader>s", ":belowright 10split<cr>:terminal ipython<cr>i", { silent = true })
