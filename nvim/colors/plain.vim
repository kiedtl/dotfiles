" Name:       plain.vim
" Version:    0.2
" Maintainer: github.com/kiedtl
" License:    The MIT License (MIT)
"
" based on: https://github.com/nerdypepper/vim-colors-plain
" which is based on: https://github.com/andreypopp/vim-colors-plain
" which is based on: https://github.com/pbrisbin/vim-colors-off
" which is based on: https://github.com/reedes/vim-colors-pencil
"
"""

hi clear

if exists('syntax on')
    syntax reset
endif

let g:colors_name='plain'

let s:black           = { "gui": "#222222", "cterm": "0"  }
let s:medium_gray     = { "gui": "#767676", "cterm": "8"  }
let s:white           = { "gui": "#F1F1F1", "cterm": "7"  }
let s:actual_white    = { "gui": "#FFFFFF", "cterm": "15" }
let s:light_black     = { "gui": "#424242", "cterm": "8"  }
let s:lighter_black   = { "gui": "#545454", "cterm": "8"  }
let s:subtle_black    = { "gui": "#303030", "cterm": "8"  }
let s:light_gray      = { "gui": "#999999", "cterm": "12" }
let s:lighter_gray    = { "gui": "#CCCCCC", "cterm": "7"  }
let s:lightest_gray   = { "gui": "#E5E5E5", "cterm": "13" }
let s:pink            = { "gui": "#FB007A", "cterm": "5"  }
let s:dark_red        = { "gui": "#C30771", "cterm": "1"  }
let s:light_red       = { "gui": "#E32791", "cterm": "1"  }
let s:orange          = { "gui": "#D75F5F", "cterm": "9"  }
let s:darker_blue     = { "gui": "#005F87", "cterm": "4"  }
let s:dark_blue       = { "gui": "#008EC4", "cterm": "4"  }
let s:blue            = { "gui": "#20BBFC", "cterm": "4"  }
let s:light_blue      = { "gui": "#B6D6FD", "cterm": "4"  }
let s:dark_cyan       = { "gui": "#20A5BA", "cterm": "6"  }
let s:light_cyan      = { "gui": "#4FB8CC", "cterm": "6"  }
let s:dark_green      = { "gui": "#10A778", "cterm": "3"  }
let s:light_green     = { "gui": "#5FD7A7", "cterm": "3"  }
let s:dark_purple     = { "gui": "#523C79", "cterm": "5"  }
let s:light_purple    = { "gui": "#6855DE", "cterm": "5"  }
let s:light_yellow    = { "gui": "#F3E430", "cterm": "2"  }
let s:dark_yellow     = { "gui": "#A89C14", "cterm": "2"  }

if &background == "dark"
  let s:bg              = s:black
  let s:bg_subtle       = s:light_black
  let s:bg_very_subtle  = s:subtle_black
  let s:norm            = s:lighter_gray
  let s:norm_subtle     = s:light_gray
  let s:purple          = s:light_purple
  let s:cyan            = s:light_cyan
  let s:green           = s:light_green
  let s:red             = s:light_red
  let s:yellow          = s:light_yellow
  let s:visual          = s:subtle_black
  let s:cursor_line     = s:subtle_black
  let s:status_line     = s:white
  let s:status_line_nc  = s:white
  let s:constant        = s:light_green
  let s:comment         = s:white
  let s:selection       = s:light_purple
  let s:warning         = s:yellow
else
  let s:bg              = s:white
  let s:bg_subtle       = s:lighter_gray
  let s:bg_very_subtle  = s:light_gray
  let s:norm            = s:light_black
  let s:norm_subtle     = s:lighter_black
  let s:purple          = s:dark_purple
  let s:cyan            = s:dark_cyan
  let s:green           = s:dark_green
  let s:red             = s:dark_red
  let s:yellow          = s:dark_yellow
  let s:visual          = s:bg_subtle
  let s:cursor_line     = s:black
  let s:constant        = s:dark_blue
  let s:comment         = s:light_gray
  let s:selection       = s:light_yellow
  let s:warning         = s:yellow
endif

" https://github.com/noahfrederick/vim-hemisu/
function! s:h(group, style)
  execute "highlight" a:group
    \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
    \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
    \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
    \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
    \ "ctermfg=" (has_key(a:style, "fg")    ? a:style.fg.cterm : "NONE")
    \ "ctermbg=" (has_key(a:style, "bg")    ? a:style.bg.cterm : "NONE")
    \ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

call s:h("Normal",        {"bg": s:bg, "fg": s:norm,})
call s:h("Noise",         {"bg": s:bg, "fg": s:norm_subtle})
call s:h("Cursor",        {"bg": s:black, "fg": s:norm})
call s:h("Comment",       {"fg": s:comment, "cterm": "italic"})
call s:h("Function",      {"fg": s:norm, "cterm": "bold"})

call s:h("Constant",      {"bg": s:bg, "fg": s:constant})
hi! link Character        Constant
hi! link Number           Constant
hi! link Boolean          Constant
hi! link Float            Constant
hi! link String           Constant

"call s:h("Identifier",    {"fg": s:dark_blue})
hi! link Identifier       Normal

"hi! link Statement        Normal
call s:h("Statement",     {"bg": s:bg, "fg": s:norm, "cterm": "bold"})
hi! link Conditonal       Statement
hi! link Repeat           Statement
hi! link Label            Statement
hi! link Operator         Noise
hi! link Keyword          Statement
hi! link Exception        Statement

"call s:h("PreProc",       {"fg": s:red})
hi! link PreProc          Normal
hi! link Include          Statement
hi! link Define           PreProc
hi! link Macro            PreProc
hi! link PreCondit        PreProc

"call s:h("Type",          {"fg": s:purple})
hi! link Type             Normal
hi! link StorageClass     Type
hi! link Structure        Type
hi! link Typedef          Type

"call s:h("Special",       {"fg": s:pink})
hi! link Special          StatusLine
hi! link SpecialChar      Special
hi! link Tag              Special
hi! link Delimiter        Special
hi! link SpecialComment   Special
hi! link Debug            Special

hi! link Conceal          NonText

call s:h("Underlined",    {"fg": s:norm, "gui": "underline", "cterm": "underline"})
call s:h("Ignore",        {"fg": s:bg})
call s:h("Error",         {"fg": s:red, "bg": s:bg, "cterm": "bold"})
call s:h("Todo",          {"fg": s:actual_white, "bg": s:black, "gui": "bold", "cterm": "bold"})
call s:h("SpecialKey",    {"fg": s:subtle_black})
call s:h("NonText",       {"fg": s:bg_very_subtle})
call s:h("Directory",     {"fg": s:dark_green})
call s:h("ErrorMsg",      {"fg": s:pink})
call s:h("IncSearch",     {"bg": s:selection, "fg": s:black})
call s:h("Search",        {"bg": s:selection, "fg": s:black})
call s:h("MoreMsg",       {"fg": s:medium_gray, "cterm": "bold", "gui": "bold"})
hi! link ModeMsg MoreMsg
call s:h("LineNr",        {"fg": s:light_gray})
call s:h("CursorLineNr",  {"fg": s:green, "bg": s:bg_very_subtle})
call s:h("Question",      {"fg": s:red})
call s:h("VertSplit",     {"bg": s:bg, "fg": s:bg_very_subtle})
call s:h("Title",         {"fg": s:white, "cterm": "bold", "gui": "bold"})
call s:h("Visual",        {"bg": s:bg_subtle})
call s:h("VisualNOS",     {"bg": s:bg_very_subtle})
call s:h("WarningMsg",    {"fg": s:warning})
call s:h("WildMenu",      {"fg": s:white, "bg": s:bg})
call s:h("Folded",        {"fg": s:medium_gray})
call s:h("FoldColumn",    {"fg": s:bg_subtle})
call s:h("DiffAdd",       {"fg": s:green})
call s:h("DiffDelete",    {"fg": s:red})
call s:h("DiffChange",    {"fg": s:dark_yellow})
call s:h("DiffText",      {"fg": s:dark_green})
call s:h("SignColumn",    {"fg": s:medium_gray})

if has("gui_running")
  call s:h("SpellBad",    {"gui": "underline", "sp": s:red})
  call s:h("SpellCap",    {"gui": "underline", "sp": s:light_green})
  call s:h("SpellRare",   {"gui": "underline", "sp": s:pink})
  call s:h("SpellLocal",  {"gui": "underline", "sp": s:dark_green})
else
  call s:h("SpellBad",    {"cterm": "underline", "fg": s:red})
  call s:h("SpellCap",    {"cterm": "underline", "fg": s:light_green})
  call s:h("SpellRare",   {"cterm": "underline", "fg": s:pink})
  call s:h("SpellLocal",  {"cterm": "underline", "fg": s:dark_green})
endif

""" Help
hi link helpHyperTextEntry Title
hi link helpHyperTextJump  String

""" StatusLine

call s:h("StatusLine",        {"bg": s:bg, "fg": s:status_line})
call s:h("StatusLineNC",      {"bg": s:bg, "fg": s:status_line_nc})

" Those are not standard but are useful to emphasis different parts of the
" status line.
call s:h("StatusLineOk",      {"gui": "underline", "bg": s:bg, "fg": s:green})
call s:h("StatusLineError",   {"gui": "underline", "bg": s:bg, "fg": s:pink})
call s:h("StatusLineWarning", {"gui": "underline", "bg": s:bg, "fg": s:warning})

call s:h("Pmenu",         {"fg": s:norm, "bg": s:bg_very_subtle})
call s:h("PmenuSel",      {"fg": s:green, "bg": s:bg_very_subtle, "gui": "bold"})
call s:h("PmenuSbar",     {"fg": s:norm, "bg": s:bg_subtle})
call s:h("PmenuThumb",    {"fg": s:norm, "bg": s:bg_subtle})

call s:h("TabLine",       {"fg": s:norm_subtle, "bg": s:bg})
call s:h("TabLineSel",    {"fg": s:bg, "bg": s:light_green, "gui": "bold", "cterm": "bold"})
call s:h("TabLineFill",   {"fg": s:norm_subtle, "bg": s:bg})

call s:h("CursorColumn",  {"bg": s:bg_very_subtle})
call s:h("CursorLine",    {"bg": s:cursor_line})
call s:h("CursorLineNr",  {"fg": s:actual_white})
call s:h("ColorColumn",   {"bg": s:bg_very_subtle})

call s:h("MatchParen",    {"bg": s:bg_subtle, "fg": s:norm})
call s:h("qfLineNr",      {"fg": s:medium_gray})

call s:h("htmlH1",        {"bg": s:bg, "fg": s:norm})
call s:h("htmlH2",        {"bg": s:bg, "fg": s:norm})
call s:h("htmlH3",        {"bg": s:bg, "fg": s:norm})
call s:h("htmlH4",        {"bg": s:bg, "fg": s:norm})
call s:h("htmlH5",        {"bg": s:bg, "fg": s:norm})
call s:h("htmlH6",        {"bg": s:bg, "fg": s:norm})

call s:h("htmlBold",      {"bg": s:bg, "fg": s:norm})
call s:h("htmlItalic",    {"bg": s:bg, "fg": s:norm})
call s:h("htmlEndTag",    {"bg": s:bg, "fg": s:norm})
call s:h("htmlTag",       {"bg": s:bg, "fg": s:norm})
call s:h("htmlTagName",   {"bg": s:bg, "fg": s:norm})
call s:h("htmlArg",       {"bg": s:bg, "fg": s:norm})
call s:h("htmlError",     {"bg": s:bg, "fg": s:red})

" JavaScript highlighting
"
call s:h("javaScript",           {"bg": s:bg, "fg": s:norm})
call s:h("javaScriptBraces",     {"bg": s:bg, "fg": s:norm})
call s:h("javaScriptNumber",     {"bg": s:bg, "fg": s:green})

hi link diffRemoved       DiffDelete
hi link diffAdded         DiffAdd

" Signify, git-gutter
hi link SignifySignAdd              LineNr
hi link SignifySignDelete           LineNr
hi link SignifySignChange           LineNr
hi link GitGutterAdd                LineNr
hi link GitGutterDelete             LineNr
hi link GitGutterChange             LineNr
hi link GitGutterChangeDelete       LineNr

hi link jsFlowTypeKeyword Statement
hi link jsFlowImportType Statement
hi link jsFunction Function
hi link jsGlobalObjects Noise
hi link jsGlobalNodeObjects Normal
hi link jsSwitchCase Constant

call s:h("jsSpreadOperator ",     {"bg": s:bg, "fg": s:selection})
hi link jsReturn jsSpreadOperator
hi link jsExport jsSpreadOperator

call s:h("rustModPath ",     {"bg": s:bg, "fg": s:lightest_gray})
hi link rustMacro jsSpreadOperator
hi link rustKeyword Noise
hi link rustDerive jsSpreadOperator
hi link rustDeriveTrait jsSpreadOperator
hi link rustAttribute jsSpreadOperator
hi link rustLifetime jsSpreadOperator

hi link shCommandSub jsSpreadOperator

hi link cFormat jsSpreadOperator

hi link StorageClass Statement

call s:h("xmlTag", {"bg": s:bg, "fg": s:constant})
hi link xmlTagName   xmlTag
hi link xmlEndTag    xmlTag
hi link xmlAttrib    xmlTag

hi link markdownH1                 Statement
hi link markdownH2                 Statement
hi link markdownH3                 Statement
hi link markdownH4                 Statement
hi link markdownH5                 Statement
hi link markdownH6                 Statement
hi link markdownListMarker         Constant
hi link markdownCode               Constant
hi link markdownCodeBlock          Constant
hi link markdownCodeDelimiter      Constant
hi link markdownHeadingDelimiter   Constant

call s:h("cssBraces",     {"bg": s:bg, "fg": s:selection})
hi link cssTextProp Noise
hi link cssTagName Normal
