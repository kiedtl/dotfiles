" install vim-plug if it isn't installed yet
if empty(glob('~/etc/nvim/autoload/plug.vim'))
	silent !curl -fLo ~/etc/nvim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


""" ----------- plugins ----------
" {{{

call plug#begin('~/etc/nvim/plugged')

" various language modes for vim
Plug 'vim-scripts/paredit.vim', {'for': 'lisp'}
Plug 'rust-lang/rust.vim',      {'for': 'rust'}
Plug 'braindead-cc/bf-vim',     {'for': 'bf'}
Plug 'ziglang/zig.vim',         {'for': 'zig'}
Plug 'ron-rs/ron.vim',          {'for': 'ron'}
Plug 'bakpakin/fennel.vim',     {'for': 'fennel'}
Plug 'janet-lang/janet.vim',    {'for': 'janet'}

" misc plugins
Plug 'Yggdroot/indentLine'                          " indentlines for spaces
Plug 'godlygeek/tabular',   {'on': 'Tabular'}       " auto-align stuff
Plug 'junegunn/goyo.vim',   {'on': 'Goyo'}          " disable distractions
Plug 'junegunn/vim-easy-align',                     " easily align CSV/TSV data
Plug 'terryma/vim-multiple-cursors'                 " multiple cursors
Plug 'tpope/vim-commentary'                         " gcc to toggle comments
Plug 'reedes/vim-wordy',    {'on': 'Wordy'}         " fix weasel/passive words
Plug 'preservim/nerdtree',  {'on': 'NerdeTreeVCS'}  " tree view of files
Plug 'reedes/vim-wheel'                             " scroll with C-k/j, keeping cursor pos

call plug#end()


" }}}
""" --------- settings ----------
" {{{

set nofoldenable                 " startoff with no folding
set foldmethod=marker
set colorcolumn=80               " show 80-character column limit
set history=100                  " the default of 20 is ridiculous
set smartcase                    " case-sensitive if search has upper-case letters
set autoindent                   " indent at level of previous line
set laststatus=2                 " enable the statusbar
set cursorline                   " highlight current line
set number                       " enable line numbers
set relativenumber               " disable relative line numbers for now
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
set conceallevel=0

""" listchars
" show tab as │, non-breaking space as ␣, trailing space as ·
" if wrap is off and the text extends beyond the screen, show a »
"     (the opposite with precedes)
set listchars=tab:\│\ ,nbsp:␣,trail:·,extends:»,precedes:«

" }}}}}}
""" ---------- functions ----------
" {{{

function! SynGroup()
	let l:s = synID(line('.'), col('.'), 1)
	echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction


" }}}
""" ---------- bindings ----------
" {{{

nmap <leader>ff :set foldenable!<cr> " toggle folding
nmap gb `[v`]                        " reselect previously yanked text
nmap Y y$                            " Make Y behave consistently
nmap Q @@                            " Ex mode is bloat

nnoremap <Leader>S :call SynGroup()<CR>
nnoremap <Leader>C :source $MYVIMRC<CR>
nnoremap <Leader>d :NERDTreeVCS<CR>
nnoremap <Leader><C-S-]> <C-w><C-]><C-w>T

" mappings for easy-align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

" remove trailing whitespace from file
nmap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" toggle search highlighting
nmap <F3> :set hlsearch!<CR> " toggle search result highlighting

" space bar toggles fold open/closed
nnoremap <Space> @=(foldlevel('.')?'za':"\<Space>")<cr>
vnoremap <Space> zf

" ugh
command! WQ wq
command! Wq wq
command! W  w
command! Q  q


" }}}
""" language-specific settings
" {{{

" set indentation settings
augroup indents
	autocmd!
	autocmd FileType lua,rs,sh   setlocal ts=4 sts=4 sw=4 expandtab
	autocmd FileType scm,lisp,fe setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" configure textwidth
augroup textwidth
	autocmd!
	autocmd FileType text,mail,markdown,gmi setlocal textwidth=75
augroup END

" enable spelling for my mail (with aerc), markdown/text, and gemini pages
augroup spelling
	autocmd!
	autocmd FileType text,mail,markdown,gmi setlocal spell
augroup END


" }}}
""" plugin-specific settings
" {{{

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

" }}}
""" colorscheme
" {{{

colorscheme default
colorscheme plain

" }}}

source ~/etc/nvim/plugin/statusbar.vim
