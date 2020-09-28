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

	let l:line.='%1* %{g:curmode[mode()]}% %2* '
	let l:line.=GitBranch()
	let l:line.=' %{ReadOnly()}% %{Modified()}% %3* '
	let l:line.=' %= %2*'
	let l:line.=' Ln %l Col %v '
	let l:line.='%1* %{FileType()}%  '

	return l:line
endfunction

function! LinePercentage()
	let l:percentage=line('.') * 100 / line('$')

	let l:percentline=''
	let l:percentline.=l:percentage
	let l:percentline.='%% '

	for i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
		if (l:percentage/10) > i
			let l:percentline.='%2*|'
		else
			let l:percentline.='%2*|'
		endif
	endfor

	let l:percentline.=' '
	return l:percentline
endfunction

function! GitBranch()
	let l:command=''
	let l:command.="sh -c 'cd "
	let l:command.=SessionDir()
	let l:command.=" && branch -n'"
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

highlight user1  ctermbg=15   ctermfg=0    cterm=NONE " for mode line
highlight user2  ctermbg=7    ctermfg=0    cterm=NONE
highlight user3  ctermbg=NONE ctermfg=7    cterm=NONE
highlight user4  ctermbg=7    ctermfg=NONE cterm=NONE

set statusline=%!StatusLine()
