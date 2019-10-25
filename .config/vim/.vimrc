" enable line numbers
set number

" initialize junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" pywal colorscheme, from dylanaraps
Plug 'dylanaraps/wal.vim'

" v mode for vim
Plug 'ollykel/v-vim'

call plug#end()


" set colorscheme
colorscheme wal