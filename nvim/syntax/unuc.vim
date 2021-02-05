if exists("b:current_syntax")
	unlet! b:current_syntax
endif

syn match Text   "^.*$"
syn match TextH1 "^#+\@!\s*.*$"

highlight def link Text   Comment
highlight def link TextH1 Title

syn include @sourceC syntax/c.vim
syn region code contains=@sourceC start="^\~\~\~$" end="^\~\~\~$"
