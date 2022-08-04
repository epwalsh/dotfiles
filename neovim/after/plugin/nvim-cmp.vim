" Setup Completion
" https://github.com/hrsh7th/nvim-cmp#recommended-configuration
"
lua <<EOF
local cmp = require('cmp')
local lspkind = require("lspkind")
cmp.setup({
  completion = {
    --- We hardcode a small delay before autocomplete suggestions pop up. See below.
    autocomplete = false
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
      select = true,
    })
  },
  -- To disable a source for a certain file type, see the example in ./ftplugin/make.lua
  sources = {
    { name = 'buffer', keyword_length = 3 },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lua' },
    { name = 'path', option = { get_cwd = function(params) return vim.fn.getcwd() end } },
    { name = 'emoji' },
    { name = 'vsnip' },
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
    completion = cmp.config.window.bordered({
      winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:CmpPmenuSel,Search:None',
    }),
    documentation = cmp.config.window.bordered(),
  },
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

" Customize colors.
"
" See https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance
" for inspiration.
"
hi! CMpPmenuSel ctermbg=Black ctermfg=NONE
hi! CmpPmenuBorder ctermfg=Cyan

hi! CmpItemAbbrDeprecated ctermbg=NONE cterm=strikethrough ctermfg=Grey

hi! CmpItemAbbrMatch ctermbg=NONE ctermfg=Blue
hi! CmpItemAbbrMatchFuzzy ctermbg=NONE ctermfg=Blue

hi! CmpItemKindVariable ctermbg=NONE ctermfg=LightBlue
hi! CmpItemKindInterface ctermbg=NONE ctermfg=LightBlue

hi! CmpItemKindText ctermbg=NONE ctermfg=Grey
hi! CmpItemKindFile ctermbg=NONE ctermfg=Grey
hi! CmpItemKindFolder ctermbg=NONE ctermfg=Grey
hi! CmpItemKindReference ctermbg=NONE ctermfg=Grey

hi! CmpItemKindConstant ctermbg=NONE ctermfg=Yellow

hi! CmpItemKindFunction ctermbg=NONE ctermfg=Magenta
hi! CmpItemKindMethod ctermbg=NONE ctermfg=Magenta
hi! CmpItemKindClass ctermbg=NONE ctermfg=Magenta
hi! CmpItemKindStruct ctermbg=NONE ctermfg=Magenta
hi! CmpItemKindModule ctermbg=NONE ctermfg=Magenta

hi! CmpItemKindKeyword ctermbg=NONE ctermfg=Cyan
hi! CmpItemKindProperty ctermbg=NONE ctermfg=Cyan
hi! CmpItemKindUnit ctermbg=NONE ctermfg=Cyan
