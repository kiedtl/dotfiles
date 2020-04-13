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
Plug 'braindead-cc/bf-vim'

" plugins
Plug 'Yggdroot/indentLine'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-conficted'
Plug 'junegunn/goyo.vim'

" multiple cursors
Plug 'terryma/vim-multiple-cursors'

call plug#end()

set laststatus=2                       " enable statusbar
set cursorline                         " highlight current line
set number                             " enable line numbers
set list
set listchars=tab:\│\ ,nbsp:␣,trail:·  " nice unicode listchars :D
set tabstop=8                          " tabs
set smarttab
set encoding=utf-8                     " set UTF-8 encoding
"set mouse=a                            " enable mouse support
set backspace=indent,eol,start         " backspace through anythign
set noincsearch                        " don't autosearch

" ;P
:command! WQ wq
:command! Wq wq
:command! W  w
:command! Q  q

" bindings
nmap <C-s> :w<CR>
imap <C-s> <Esc>:w<CR>

" remove trailing whitespace from file
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>:retab<CR>

" configure tabs when editing Rust/Scheme/POSIX-sh code
augroup indents
	autocmd!
		autocmd FileType rs,sh,scm setlocal ts=4 sts=4 sw=4 expandtab
augroup END

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

" :( syntax makes vim laggy on rpi
syntax off

highlight linenr ctermfg=NONE
highlight cursorlinenr term=bold ctermfg=1 ctermbg=NONE
highlight cursorline ctermfg=16 ctermbg=8
highlight comment ctermfg=16
highlight pmenu ctermbg=0 ctermfg=NONE
highlight pmenusel ctermbg=4 ctermfg=0
highlight pmenusbar ctermbg=0
highlight pmenuthumb ctermbg=7
highlight matchparen ctermbg=0 ctermfg=NONE
