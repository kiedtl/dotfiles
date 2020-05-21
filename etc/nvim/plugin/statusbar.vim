"
" kiedtl's vim status bar, for the most part
" stolen from NerdyPepper and addy-fe :^)
"
" https://github.com/kiedtl/dotfiles
"
scriptencoding utf-8

let g:curmode={
	\ 'n'  : 'NORMAL ',
	\ 'no' : 'N·OPERATOR PENDING ',
	\ 'v'  : 'VISUAL ',
	\ 'V'  : 'V·LINE ',
	\ '^V' : 'V·BLOCK ',
	\ 's'  : 'SELECT ',
	\ 'S'  : 'S·LINE ',
	\ '^S' : 'S·BLOCK ',
	\ 'i'  : 'INSERT ',
	\ 'R'  : 'REPLACE ',
	\ 'Rv' : 'V·REPLACE ',
	\ 'c'  : 'COMMAND ',
	\ 'cv' : 'VIM EX ',
	\ 'ce' : 'EX ',
	\ 'r'  : 'PROMPT ',
	\ 'rm' : 'MORE ',
	\ 'r?' : 'CONFIRM ',
	\ '!'  : 'SHELL ',
	\ 't'  : 'TERMINAL '}

function! StatusLine() abort
	let l:line=''

	" help or man pages
	if &filetype ==# 'help' || &filetype ==# 'man'
		let l:line.=' %#StatusLineNC# ['. &filetype .'] %f '
		return l:line
	endif

	let l:line.='%1* %{g:curmode[mode()]}% %3* '
	let l:line.='Ln %l Col %v '
	let l:line.='%{ReadOnly()}% %{Modified()}% %4* '
	let l:line.=' %= %3* '
	let l:line.=LinePercentage()
	let l:line.='%1* %{FileType()}%  '

	return l:line
endfunction

function! LinePercentage()
	let l:percentage=line('.') * 100 / line('$')

	let l:percentline=''
	let l:percentline.='%5*'
	let l:percentline.=l:percentage
	let l:percentline.='%% '

	for i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
		if (l:percentage/10) > i
			let l:percentline.='%3*▒'
		else
			let l:percentline.='%4*▒'
		endif
	endfor

	let l:percentline.=' '
	return l:percentline
endfunction

" disabled, this is causes the statusline to be
" incredibly laggy on the RPi 0
function! GitBranch()
	let l:command=''
	let l:command.="sh -c 'cd "
	let l:command.=SessionDir()
	let l:command.=" && bra -n'"
	return system(l:command)
endfunction

function! FileType() abort
	if len(&filetype) == 0
		return 'TEXT'
	endif

	return toupper(&filetype)
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
		return '[RO] '
	elseif !&modifiable && !&readonly
		return ''
	else
		return ''
	endif
endfunction

function! Modified() abort
	if &modified
		return '[+] '
	else
		return ''
	endif
endfunction

highlight user1 ctermbg=7    ctermfg=0
highlight user3 ctermbg=NONE ctermfg=NONE
highlight user4 ctermbg=NONE ctermfg=3
highlight user5 ctermbg=NONE ctermfg=7

set statusline=%!StatusLine()
