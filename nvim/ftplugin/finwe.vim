if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

" Consider print-string to be a single word, rather than 'print' + 'string'
setlocal iskeyword=!,%,*,+,-,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,126,38,94

"setlocal define=(word\s*\k\+

setlocal commentstring=//\ %s
setlocal noexpandtab
setlocal tabstop=3 " muahah
setlocal shiftwidth=0
setlocal softtabstop=0
setlocal textwidth=80

" hard-wrap only comment lines and auto-insert the // when hitting enter
setlocal fo-=t fo+=croql
