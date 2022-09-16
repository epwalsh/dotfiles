" Setup Completion
" https://github.com/hrsh7th/nvim-cmp#recommended-configuration
"
lua <<EOF
local cmp = require "cmp"
local lspkind = require "lspkind"

-- Load custom github handles source from ./lua/cmp/github_handles.lua
cmp.register_source("github_handles", require("cmp.github_handles").new())
 
-- General setup.
cmp.setup({
  completion = {
    -- We hardcode a small delay before autocomplete suggestions pop up. See below.
    autocomplete = false,
  },
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'path', option = { get_cwd = function(params) return vim.fn.getcwd() end } },
    { name = 'emoji' },
    { name = 'vsnip' },
    { name = 'buffer', keyword_length = 3 },
    { name = 'calc' },
    { name = 'dictionary' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      menu = ({
        buffer = '[Buffer]',
        nvim_lsp = '[LSP]',
        obsidian = '[Obsidian]',
        obsidian_new = '[Obsidian]',
      }),
    })
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- Filetype specific setup.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'buffer', keyword_length = 3 },
    { name = 'path', option = { get_cwd = function(params) return vim.fn.getcwd() end } },
    { name = 'emoji' },
    { name = "github_handles" },  -- from ./lua/cmp/github_handles.lua
  })
})

cmp.setup.filetype('make', {
  sources = cmp.config.sources({
    { name = 'buffer', keyword_length = 3 },
    { name = 'path', option = { get_cwd = function(params) return vim.fn.getcwd() end } },
  })
})

cmp.setup.filetype('markdown', {
  sources = cmp.config.sources({
    { name = 'buffer', keyword_length = 3 },
    { name = 'path', option = { get_cwd = function(params) return vim.fn.getcwd() end } },
    { name = 'vsnip' },
    { name = 'calc' },
    { name = 'dictionary', keyword_length = 3 },
  })
})

cmp.setup.filetype('yaml', {
  sources = cmp.config.sources({
    { name = 'buffer', keyword_length = 3 },
    { name = 'path', option = { get_cwd = function(params) return vim.fn.getcwd() end } },
    { name = 'calc' },
    { name = 'emoji', option = { insert = true } },
    { name = 'dictionary', keyword_length = 3 },
  })
})

-- cmp-dictionary setup
require("cmp_dictionary").setup({
  dic = { ["markdown"] = { vim.fs.normalize("~/.config/nvim/spell/en.utf-8.add"), "/usr/share/dict/words" } }
})
EOF

" Trigger completion on an idle timer.
"
autocmd TextChangedI * call s:on_text_changed()

let s:timer = 0

function! s:on_text_changed() abort
  call timer_stop(s:timer)
  let s:timer = timer_start(200, function('s:complete'))
endfunction

function! s:complete(...) abort
  lua require('cmp').complete({ reason = require('cmp').ContextReason.Auto })
endfunction
