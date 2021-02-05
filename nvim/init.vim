" install vim-plug if it isn't installed yet
if empty(glob('~/etc/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/etc/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


""" ----------- plugins ----------
call plug#begin('~/etc/nvim/plugged')

" various language modes for vim
Plug 'vim-scripts/paredit.vim', {'for': 'lisp'}
Plug 'rust-lang/rust.vim',      {'for': 'rust'}
Plug 'braindead-cc/bf-vim',     {'for': 'bf'}
Plug 'ziglang/zig.vim',         {'for': 'zig'}
Plug 'ron-rs/ron.vim',          {'for': 'ron'}
Plug 'bakpakin/fennel.vim',     {'for': 'fennel'}

" misc plugins
Plug 'Yggdroot/indentLine'                          " indentlines for spaces
Plug 'godlygeek/tabular',   {'on': 'Tabular'}       " auto-align stuff
Plug 'junegunn/goyo.vim',   {'on': 'Goyo'}          " disable distractions
Plug 'terryma/vim-multiple-cursors'                 " multiple cursors
Plug 'tpope/vim-commentary'                         " gcc to toggle comments
Plug 'reedes/vim-wordy',    {'on': 'Wordy'}         " fix weasel/passive words
Plug 'preservim/nerdtree',  {'on': 'NerdeTreeVCS'}  " tree view of files
Plug 'reedes/vim-wheel'                             " scroll with C-k/j, keeping cursor pos

call plug#end()


""" --------- settings ----------

set history=100                  " the default of 20 is ridiculous
set smartcase                    " case-sensitive if search has upper-case letters
set autoindent                   " indent at level of previous line
set laststatus=2                 " enable the statusbar
set nocursorline                 " don't highlight current line
set number                       " enable line numbers
set norelativenumber             " disable relative line numbers for now
set list                         " enable listchars (see below)
set tabstop=8                    " show tabs as 4 spaces instead of 8
set smarttab
set encoding=utf-8               " set UTF-8 encoding
set backspace=indent,eol,start   " backspace through anything
set noincsearch                  " don't autosearch
set wrap                         " wrap long lines, please!
set mouse=                       " disable the pesky mouse support
set mousehide                    " hide mouse while typing
set scrolloff=3                  " lines to keep above/below cursor when scrolling
set showmatch                    " show matching brackets/parens
set fillchars=eob:\              " remove the annoying tildes at the end of a file

""" listchars
" show tab as │, non-breaking space as ␣, trailing space as ·
" if wrap is off and the text extends beyond the screen, show a »
"     (the opposite with precedes)
set listchars=tab:\│\ ,nbsp:␣,trail:·,extends:»,precedes:«


""" ---------- functions ----------
function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction

function! FzyCommand(choice_command, vim_command)
	try
		let output = system(a:choice_command . " | fzy ")
	catch /Vim:Interrupt/
		" Swallow errors from ^C, allow redraw! below
	endtry
	redraw!
	if v:shell_error == 0 && !empty(output)
		exec a:vim_command . ' ' . output
	endif
endfunction


""" ---------- bindings ----------
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>
nmap gb `[v`]           " reselect previously yanked text
nmap <Leader>C :source $MYVIMRC<CR>
nmap <Leader>d :NERDTreeVCS<CR>
nmap <leader>e :call FzyCommand("rg . -l", ":e")<cr>
nmap <leader>v :call FzyCommand("rg . -l", ":vs")<cr>
nmap <leader>s :call FzyCommand("rg . -l", ":sp")<cr>

" remove trailing whitespace from file
nmap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>
nmap <F3> :set hlsearch!<CR> " toggle search result highlighting

" ugh
command! WQ wq
command! Wq wq
command! W  w
command! Q  q


" --------------

" set indentation settings
augroup indents
	autocmd!
	autocmd FileType rs,sh setlocal ts=4 sts=4 sw=4 expandtab
	autocmd FileType scm,lisp,fe setlocal ts=2 sts=2 sw=2 expandtab
	autocmd FileType lua setlocal ts=4 sts=4 sw=4 expandtab
augroup END

" configure textwidth
augroup textwidth
	autocmd!
	autocmd FileType text,markdown setlocal textwidth=75
augroup END

" enable spelling for my mail (with aerc), markdown/text, and gemini pages
augroup spelling
	autocmd!
	autocmd FileType text,mail,markdown,gmi setlocal spell
augroup END

" --------------

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

colorscheme plain

highlight linenr       ctermfg=NONE
highlight clear        cursorline
highlight cursorlinenr ctermfg=15    ctermbg=NONE
highlight cursorline   ctermfg=NONE  ctermbg=NONE
highlight comment      ctermfg=15
highlight pmenu        ctermbg=0     ctermfg=NONE
highlight pmenusel     ctermbg=4     ctermfg=0
highlight pmenusbar    ctermbg=0
highlight pmenuthumb   ctermbg=15
highlight matchparen   ctermbg=0     ctermfg=NONE
highlight nontext      ctermbg=NONE  ctermfg=8
