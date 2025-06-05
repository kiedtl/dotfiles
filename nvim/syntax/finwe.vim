" Vim syntax file
" " Language: finwe
" " Maintainer: kiedtl <kiedtl@tilde.team>
" " Latest Revision: 20 September 2024

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn keyword   finwe_Keyword     word when cond test while until r wild let
syn keyword   finwe_Keyword     use use*
syn keyword   finwe_Keyword     sw continue break return split
syn keyword   finwe_Keyword     should of make debug asm
syn keyword   finwe_Keyword     device struct enum typealias
syn keyword   finwe_Notes       contained TODO FIXME XXX NOTE

" Stack operators
syn keyword   finwe_StackOp     swap rot over nip tuck
syn keyword   finwe_StackOp     drop 2drop 3drop
syn keyword   finwe_StackOp     dup 2dup
syn keyword   finwe_StackOp     tuck> rot>
syn keyword   finwe_StackOp     swap-bs swap-sb over-bs over-sb
syn keyword   finwe_StackOp     rot-bss rot-sbs rot-ssb rot-bbs rot-sbb

" Allows adding matches for special things in comments.
syn cluster finwe_CommentGroup  contains=finwe_Notes

" Literals
syn match   finwe_Decimal     display "\<[0-9][0-9_]*i?s?"
syn match   finwe_Hexadecimal display "\<0x[a-fA-F0-9_]\+i?s?"
syn match   finwe_Octal       display "\<0o[0-7_]\+i?s?"
syn match   finwe_Binary      display "\<0b[01_]\+i?s?"
syn match   finwe_Character   display /b'./
syn region  finwe_String      display start=+"+ end=+"+ contains=@Spell

" Special chars
syn match finwe_Ref          "@"
syn match finwe_Deref        "$"
syn match finwe_Child        "\:"

" Comments
syn match finwe_CommentLine  "//.*$" contains=finwe_Notes,@Spell

"syn region zf_CommentBlock        matchgroup=zf_CommentBlock  start="(" end=")" contains=zf_Notes,zf_CommentBlockNested,@Spell
"syn region zf_CommentBlockNested  matchgroup=zf_CommentBlock  start="(" end=")" contains=zf_Notes,zf_CommentBlockNested,@Spell contained transparent


" Areas
syn region finwe_Block     matchgroup=finwe_Parens start="\[" end="]" contains=@finwe_All fold
syn region finwe_Statement matchgroup=finwe_Parens start="("  end=")" contains=@finwe_All fold
syn match  finwe_Macro '#\w\(\w\)*'

" Highlight superfluous closing parens, brackets and braces.
syn match finwe_Error "]\|)"

syn cluster finwe_All contains=@Spell,finwe_Ref,finwe_Deref,finwe_Child,finwe_Block,finwe_Statement,finwe_Char,finwe_String,finwe_Keyword,finwe_Number,finwe_StackOp,finwe_CommentLine

syn sync fromstart

hi def link finwe_Keyword      Keyword
hi def link finwe_Notes        Todo
hi def link finwe_Decimal      finwe_Number
hi def link finwe_Hexadecimal  finwe_Number
hi def link finwe_Octal        finwe_Number
hi def link finwe_Binary       finwe_Number
hi def link finwe_Number       Number
hi def link finwe_String       String
hi def link finwe_Character    Character
hi def link finwe_CommentLine  Comment
hi def link finwe_Error        Error
hi def link finwe_Ref          SpecialChar
hi def link finwe_Deref        SpecialChar
hi def link finwe_Child        SpecialChar
hi def link finwe_Parens       Delimiter
hi def link finwe_Macro        Macro

"hi def link finwe_CommentBlock Comment
