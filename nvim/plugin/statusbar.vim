"
" kiedtl's vim status bar, for the most part
" stolen from NerdyPepper and addy-fe :^)
"
" https://github.com/kiedtl/dotfiles
"

scriptencoding utf-8

let g:curmode={
	\ 'n'  : 'NORMAL',
	\ 'no' : 'N·OPERATOR PENDING',
	\ 'v'  : 'VISUAL',
	\ 'V'  : 'V·LINE',
	\ '' : 'V·BLOCK',
	\ 's'  : 'SELECTION',
	\ 'S'  : 'S·LINE',
	\ '' : 'S·BLOCK',
	\ 'i'  : 'INSERT',
	\ 'R'  : 'REPLACE',
	\ 'Rv' : 'V·REPLACE',
	\ 'c'  : 'COMMAND',
	\ 'cv' : 'VIM EX',
	\ 'ce' : 'EX',
	\ 'r'  : 'PROMPT',
	\ 'rm' : 'MOAR',
	\ 'r?' : 'CONFIRM',
	\ '!'  : 'SHELL',
	\ 't'  : 'TERMINAL'}

function! StatusLine() abort
	let l:line=''

	" u/Nerdypepper-esque theme theme
	highlight user1  ctermbg=7    ctermfg=0    cterm=NONE
	highlight user2  ctermbg=8    ctermfg=15   cterm=NONE
	highlight user3  ctermbg=8    ctermfg=7    cterm=bold
	highlight user4  ctermbg=NONE ctermfg=NONE cterm=NONE
	highlight user7  ctermbg=NONE ctermfg=8    cterm=NONE
	highlight user8  ctermbg=8    ctermfg=0    cterm=NONE
	highlight user9  ctermbg=8    ctermfg=7    cterm=NONE
	let l:line.='%9*%1* %{g:curmode[mode()]}%  %9*%2* '
	let l:line.=' '
	let l:line.=GitBranch()
	let l:line.=' %7*%4* '
	let l:line.='%t %{ReadOnly()}% %{Modified()}%'
	let l:line.=' %7*%4* '
	let l:line.=&fileformat
	let l:line.=' %= '
	"let l:line.=' '
	"let l:line.=LinePercentageBar()
	let l:line.='%7*%2* Ln %l Col %v '
	let l:line.='%9*%1* '
	let l:line.=GetIcon()
	let l:line.=' '
	let l:line.=FileType()
	let l:line.=' %9*'


	" Emacs-esque theme (I guess? I cannot remember the
	" last time I was forced to use that monstrosity)

" 	if &filetype ==# 'help' || &filetype ==# 'man'
" 		" help or man pages
" 		let l:line.='%3* %l%2*:%v'
" 		let l:line.='%1* %t'
" 		let l:line.='%='
" 		let l:line.='%3*%P '
" 		let l:line.='%1*<%{g:curmode[mode()]}% >  '
" 		let l:line.='%1*(%{FileType()}% )'
" 	else
" 		let l:line.='%3* %l%2*:%v '
" 		let l:line.='%2*%{EmacsFileEncoding()}% %{LineEndings()}% '
" 		let l:line.='%3*%{EmacsModRO()}% %1* %t '
" 		let l:line.='%='
" 		let l:line.='%3*%P '
" 		let l:line.='%1*<%{g:curmode[mode()]}% >  '
" 		let l:line.='%3*:%{GitBranch()}%  '
" 		let l:line.='%1*(%{FileType()}% )'
" 	endif
" 	let l:line.='                   '

	return l:line
endfunction

function! LinePercentageBar()
	let l:percentage=line('.') * 100 / line('$')

	let l:percentline=''
	"let l:percentline.=l:percentage
	"let l:percentline.='%% '

	for i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
		if (l:percentage/10) > i
			let l:percentline.='%4*|'
		else
			let l:percentline.='%7*|'
		endif
	endfor

	let l:percentline.=' '
	return l:percentline
endfunction

function! GitBranch() abort
	let l:command=''
	let l:command.="sh -c 'cd "
	let l:command.=SessionDir()
	let l:command.=" && branch -n'"
	return system(l:command)
endfunction

lua get_icon = function(name, ext) if ext == nil or ext == "" then return "" else return require('nvim-web-devicons').get_icon(name, ext):match("[%z\1-\127\194-\244][\128-\191]*") end end
function! GetIcon() abort
	
	let l:LuaGetIcon = luaeval("get_icon")
	let l:result=''
	silent! let l:result=LuaGetIcon(expand("%:t"), expand("%:e"))
	return l:result
endfunction

function! FileType() abort
	if len(&filetype) == 0
		return 'text'
	endif

	return tolower(&filetype)
endfunction

function! SessionDir() abort
	if len(argv()) > 0
		return fnamemodify(argv()[0], ':p:h')
	endif

	return getcwd()
endfunction

function! ReadOnly() abort
	if !&modifiable && &readonly
		return '[RO] '
	elseif &modifiable && &readonly
		return '[MRO] '
	elseif !&modifiable && !&readonly
		return ''
	else
		return ''
	endif
endfunction

function! Modified() abort
	if &modified
		"return '[+] '
		return ' '
	else
		return ''
	endif
endfunction

function! EmacsModRO() abort
	if &readonly
		if &modified
			return '%*'
		else
			return '%%'
		endif
	else
		if &modified
			return '**'
		else
			return '--'
		endif
	endif
endfunction

function! LineEndings() abort
	if &fileformat ==# 'unix'
		return ':'
	elseif &fileformat ==# 'dos'
		return '(DOS)'
	elseif &fileformat ==# 'mac'
		return '(MAC)'
	else
		return '(???)'
	endif
endfunction

function! EmacsFileEncoding() abort
	if &fileencoding ==# 'ucs-bom'
		return 'U'
	elseif &fileencoding ==# 'utf-8' || &fileencoding ==# ''
		return 'u'
	elseif &fileencoding ==# 'default'
		return 'd'
	elseif &fileencoding ==# 'latin1'
		return '1'
	else
		return '?'
	endif
endfunction

set statusline=%!StatusLine()
" Reset highlights
call StatusLine()

" Emacs theme
"highlight user1  ctermbg=251 ctermfg=7    cterm=NONE
"highlight user2  ctermbg=251 ctermfg=6    cterm=NONE
"highlight user3  ctermbg=251 ctermfg=7    cterm=bold
"highlight user4  ctermbg=251 ctermfg=NONE cterm=NONE
