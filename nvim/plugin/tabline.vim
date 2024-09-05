" https://stackoverflow.com/questions/33710069/how-to-write-tabline-function-in-vim

set tabline=%!MyTabLine()	" custom tab pages line

function! MyTabLine()
	let s = ''
	" loop through each tab page
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif
		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T '
		" set page number string
		let s .= i + 1 . ''
		" get buffer names and statuses
		let n = ''  " temp str for buf names
		let m = 0   " &modified counter
		let buflist = tabpagebuflist(i + 1)
		" loop through each buffer in a tab
		for b in buflist
			if getbufvar(b, "&buftype") == 'help'
				" let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
			elseif getbufvar(b, "&buftype") == 'quickfix'
				" let n .= '[Q]'
			elseif getbufvar(b, "&modifiable")
				let n .= fnamemodify(bufname(b), ':t') . ', '
			endif
			if getbufvar(b, "&modified")
				let m += 1
			endif
		endfor
		" let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
		let n = substitute(n, ', $', '', '')
		" add modified label
		if m > 0
			let s .= '+'
			" let s .= '[' . m . '+]'
		endif
		if i + 1 == tabpagenr()
			let s .= ' %#TabLineSel#'
		else
			let s .= ' %#TabLine#'
		endif
		" add buffer names
		if n == ''
			let s.= '[Unsaved]'
		else
			let s .= n
		endif
		" switch to no underlining and add final space
		let s .= ' '
	endfor
	let s .= '%#TabLineFill#%T'
	" right-aligned close button
	if tabpagenr('$') > 1
		let s .= '%=%#TabLineFill#%999X×'
	endif
	return s
endfunction
