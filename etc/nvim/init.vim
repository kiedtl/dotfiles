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

" plugins
Plug 'Yggdroot/indentLine'
Plug 'godlygeek/tabular'
Plug 'junegunn/goyo.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'danilamihailov/vim-tips-wiki'

call plug#end()

set laststatus=2                       " enable statusbar
set nocursorline                       " don't highlight current line
set number                             " enable line numbers
set relativenumber                     " enable relative line numbers
set list                               " enable listchars
set listchars=tab:\│\ ,nbsp:␣,trail:·  " nice unicode listchars :D
set tabstop=8                          " tabs
set smarttab
set encoding=utf-8                     " set UTF-8 encoding
set backspace=indent,eol,start         " backspace through anything
set noincsearch                        " don't autosearch

" ;P
:command! WQ wq
:command! Wq wq
:command! W  w
:command! Q  q

" bindings
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>
nmap gb `[v`]           " reselect previously yanked text

" remove trailing whitespace from file
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" configure tabs when editing Rust/Scheme/POSIX-sh code
augroup indents
	autocmd!
		autocmd FileType rs,sh setlocal ts=4 sts=4 sw=4 expandtab
		autocmd FileType scm,lisp setlocal ts=2 sts=2 sw=2 expandtab
augroup END

" for markdown
augroup plaintext
	autocmd!
		autocmd FileType text,markdown setlocal textwidth=75
augroup END

augroup highlight_follows_vim
	autocmd!
		autocmd WinEnter * set cursorline
		autocmd WinLeave * set nocursorline
augroup END

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

" syntax makes vim laggy on RPi 0 :'(
" and anyway, syntax highlighting is bloat
syntax off

highlight linenr       ctermfg=NONE
highlight clear        cursorline
highlight cursorlinenr ctermfg=1     ctermbg=NONE
highlight cursorline   ctermfg=16    ctermbg=8
highlight comment      ctermfg=16
highlight pmenu        ctermbg=0     ctermfg=NONE
highlight pmenusel     ctermbg=4     ctermfg=0
highlight pmenusbar    ctermbg=0
highlight pmenuthumb   ctermbg=7
highlight matchparen   ctermbg=0     ctermfg=NONE
