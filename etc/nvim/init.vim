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
Plug 'rust-lang/rust.vim'
Plug 'ollykel/v-vim'

" plugins
Plug 'Yggdroot/indentLine'
Plug 'godlygeek/tabular'

" multiple cursors
Plug 'terryma/vim-multiple-cursors'

call plug#end()

set list
set number                             " enable line numbers
set listchars=tab:»\ ,nbsp:␣,trail:·
set tabstop=8                          " tabs
set smarttab
set encoding=utf-8                     " set UTF-8 encoding
set mouse=a                            " enable mouse support
colorscheme plain                      " colorscheme
set backspace=indent,eol,start         " backspace through anythign
set scrolloff=1                        " show one line above/below cursor
set incsearch=0                        " don't autosearch

" ;P
:command! WQ wq
:command! Wq wq
:command! W  w
:command! Q  q

" remove trailing whitespace from file
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" configure tabs when editing Rust code
augroup rustdev
	autocmd!
		autocmd FileType rs setlocal ts=4 sts=4 sw=4 expandtab
augroup END

let g:indentLine_setColors = 1
let g:indentLine_char      = '»'
let g:ft_man_open_mode     = 'tab'
