"
" kiedtl's vim status bar
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

	let l:line.='%1* %{g:curmode[mode()]}% '
	let l:line.='%3* %{GitBranch()}%  %4*'
	let l:line.=' %f %{ReadOnly()}% %{Modified()}% '
	let l:line.='%= '
	let l:line.='%3* Ln %l, Col %c %2* %{FileType()}%  '

	return l:line
endfunction

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

highlight user1 ctermbg=1 ctermfg=0
highlight user2 ctermbg=1 ctermfg=0
highlight user3 ctermbg=8 ctermfg=NONE
highlight user4 ctermbg=NONE ctermfg=NONE
highlight group1 ctermbg=NONE ctermfg=0

set statusline=%!StatusLine()
