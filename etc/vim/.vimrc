" install vim-plug if it isn't installed yet
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" initialize junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" pywal colorscheme, from dylanaraps
Plug 'dylanaraps/wal.vim'

" Rust mode for vim
Plug 'rust-lang/rust.vim'

" V mode for vim
Plug 'ollykel/v-vim'

" multiple cursors
" Plug 'terryma/vim-multiple-cursors'

" vim-airline: powerline alternative written in pure vimscript.
" No bloated Python interpreter needed!
" Plug 'vim-airline/vim-airline'

" vim-airline themes
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" enable line numbers
set number

" tabs
set tabstop=8
set smarttab

" UTF8
set encoding=utf-8

" enable mouse
set mouse=a

" set colorscheme
colorscheme wal

" remove trailing whitespace from file
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>
