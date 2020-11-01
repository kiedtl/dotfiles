" install vim-plug if it isn't installed yet
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/etc/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" initialize junegunn/vim-plug
call plug#begin('~/etc/nvim/plugged')

" colorschemes
Plug 'nerdypepper/vim-colors-plain', { 'branch': 'duotone' }

" various language modes for vim
Plug 'vim-scripts/paredit.vim', {'for' : 'lisp'}
Plug 'rust-lang/rust.vim',      {'for' : 'rust'}
Plug 'ollykel/v-vim',           {'for' : 'v'}
Plug 'braindead-cc/bf-vim',     {'for' : 'brainfuck'}
Plug 'ziglang/zig.vim',         {'for' : 'zig'}
Plug 'ron-rs/ron.vim'

" misc plugins
Plug 'Yggdroot/indentLine'            " show indentlines for spaces
Plug 'godlygeek/tabular'              " tabular
Plug 'junegunn/goyo.vim'              " distraction-free writing
Plug 'terryma/vim-multiple-cursors'   " multiple cursors
Plug 'tpope/vim-commentary'           " gcc to toggle comments
Plug 'reedes/vim-wordy'               " fix weasel words/passive voice
Plug 'preservim/nerdtree'             " should be obvious

call plug#end()

set history=1000                 " the default of 20 is ridiculous
set smartcase                    " case-sensitive if search contains
                                 " an upper-case letter
set autoindent                   " indent at level of prev line
set laststatus=2                 " enable the statusbar
set nocursorline                 " don't highlight current line
set number                       " enable line numbers
set relativenumber               " enable relative line numbers
set list                         " enable listchars
set tabstop=8                    " tabs
set smarttab
set encoding=utf-8               " set UTF-8 encoding
set backspace=indent,eol,start   " backspace through anything
set noincsearch                  " don't autosearch
set wrap                         " wrap long lines, please!
set mouse=                       " disable the pesky mouse
set mousehide                    " hide mouse while typing
set scrolloff=3                  " lines to keep above/below cursor
set showmatch                    " show matching brackets/parens
set foldmethod=indent            " fold lines of same indent
set cursorline                   " highlight current line

" show tab as │, non-breaking space as ␣, trailing space as ·
" if wrap is off and the text extends beyond the screen, show a »
"     (the opposite with precedes)
set listchars=tab:\│\ ,nbsp:␣,trail:·,extends:»,precedes:«

" ;P
:command! WQ wq
:command! Wq wq
:command! W  w
:command! Q  q

" bindings
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>
nmap gb `[v`]           " reselect previously yanked text
nmap gt :NERDTreeVCS<CR>

" remove trailing whitespace from file
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" configure tabs when editing Rust/Scheme/POSIX-sh code
augroup indents
	autocmd!
		autocmd FileType rs,sh setlocal ts=4 sts=4 sw=4 expandtab
		autocmd FileType scm,lisp,fe setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" for markdown
augroup plaintext
	autocmd!
		autocmd FileType text,markdown setlocal textwidth=75
augroup END

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

colorscheme default
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
