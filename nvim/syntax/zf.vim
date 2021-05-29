" Vim syntax file
" " Language: zf
" " Maintainer: kiedtl <kiedtl@tilde.team>
" " Latest Revision: 05 April 2021

if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

syn keyword   zf_Keyword     if orelse until word cond any is?
syn keyword   zf_Keyword     sw continue break loop
syn keyword   zf_Notes       contained TODO FIXME XXX NOTE

" Allows adding matches for special things in comments.
syn cluster zf_CommentGroup  contains=zf_Notes

" Ligatures
syn match zf_LeftDoubleBracket   /\[\[/       contains=zf_LeftDoubleBracket1,zf_LeftDoubleBracket2
syn match zf_LeftDoubleBracket1  /\[/         contained conceal cchar=
syn match zf_LeftDoubleBracket2  /\[\@<=\[/   contained conceal cchar=
syn match zf_RightDoubleBracket   /\]\]/      contains=zf_RightDoubleBracket1,zf_RightDoubleBracket2
syn match zf_RightDoubleBracket1  /\]/        contained conceal cchar=
syn match zf_RightDoubleBracket2  /\]\@<=\]/  contained conceal cchar=

" Literals
syn match   zf_Decimal     display "\<[0-9][0-9_]*"
syn match   zf_Hexadecimal display "\<0x[a-fA-F0-9_]\+"
syn match   zf_Octal       display "\<0o[0-7_]\+"
syn match   zf_Binary      display "\<0b[01_]\+"
syn match   zf_Character   display /b'.'/
syn region  zf_String      display start=+"+ end=+"+ contains=@Spell

" Comments
syn region zf_CommentLine                                     start="\\"    end="$"   contains=zf_Notes,@Spell
syn region zf_CommentBlock        matchgroup=zf_CommentBlock  start="(" end=")" contains=zf_Notes,zf_CommentBlockNested,@Spell
syn region zf_CommentBlockNested  matchgroup=zf_CommentBlock  start="(" end=")" contains=zf_Notes,zf_CommentBlockNested,@Spell contained transparent

" Other
syn region zf_FoldBraces   start="\[\[" end="\]\]" transparent fold


hi def link zf_Keyword      Keyword
hi def link zf_Notes        Todo
hi def link zf_Decimal      zf_Number
hi def link zf_Hexadecimal  zf_Number
hi def link zf_Octal        zf_Number
hi def link zf_Binary       zf_Number
hi def link zf_Number       Number
hi def link zf_String       String
hi def link zf_Character    Character
hi def link zf_CommentLine  Comment
hi def link zf_CommentBlock Comment
