syntax match my_todo '\v(\s+)?-\s\[\s\]'hs=e-4 conceal cchar=☐
syntax match my_todo_done '\v(\s+)?-\s\[x\]'hs=e-4 conceal cchar=✔

" Zettel Links
" [[link|name]]
syntax region ZettelLink matchgroup=ZettelLinkDelim start="\v\[\[[^\|]+\|" end="\]\]" oneline concealends
highlight ZettelLink cterm=underline ctermfg=blue
" Same thing, but in headers
syntax region ZettelLinkHeader matchgroup=ZettelLinkDelim start="\v\[\[[^\|]+\|" end="\]\]" oneline concealends
highlight ZettelLinkHeader cterm=underline,bold ctermfg=166

" Need to override these region definitions from vim-markdown to contain our ZettelLink / ZettelLinkHeader.
syn region mkdListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@mkdNonListItem,mkdListItem,@Spell,ZettelLink
syn region mkdNonListItemBlock start="\(\%^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@!\|\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!\)" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell,ZettelLink
syn region htmlH1       matchgroup=mkdHeading     start="^\s*#"                   end="$" contains=mkdLink,mkdInlineURL,@Spell,ZettelLinkHeader
syn region htmlH2       matchgroup=mkdHeading     start="^\s*##"                  end="$" contains=mkdLink,mkdInlineURL,@Spell,ZettelLinkHeader
syn region htmlH3       matchgroup=mkdHeading     start="^\s*###"                 end="$" contains=mkdLink,mkdInlineURL,@Spell,ZettelLinkHeader
syn region htmlH4       matchgroup=mkdHeading     start="^\s*####"                end="$" contains=mkdLink,mkdInlineURL,@Spell,ZettelLinkHeader
syn region htmlH5       matchgroup=mkdHeading     start="^\s*#####"               end="$" contains=mkdLink,mkdInlineURL,@Spell,ZettelLinkHeader
syn region htmlH6       matchgroup=mkdHeading     start="^\s*######"              end="$" contains=mkdLink,mkdInlineURL,@Spell,ZettelLinkHeader
