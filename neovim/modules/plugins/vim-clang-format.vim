let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "AlignConsecutiveAssignments": "true",
            \ "AllowAllParametersOfDeclarationOnNextLine": "true",
            \ "BinPackArguments": "false",
            \ "BinPackParameters": "false",
            \ "BreakBeforeBraces": "Linux",
            \ "SpacesInAngles": "false",
            \ "PointerAlignment": "Right",
            \ "MaxEmptyLinesToKeep": 2,
            \ "Standard" : "C++11"}
" See http://clang.llvm.org/docs/ClangFormatStyleOptions.html for a full list
" of options.

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
