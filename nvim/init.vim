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
Plug 'kaarmu/typst.vim'

" misc plugins
Plug 'j-hui/fidget.nvim'
Plug 'Yggdroot/indentLine'                          " indentlines for spaces
Plug 'godlygeek/tabular',   {'on': 'Tabular'}       " auto-align stuff
Plug 'junegunn/goyo.vim',   {'on': 'Goyo'}          " disable distractions
Plug 'junegunn/vim-easy-align',                     " easily align CSV/TSV data
Plug 'terryma/vim-multiple-cursors'                 " multiple cursors
Plug 'tpope/vim-commentary'                         " gcc to toggle comments
Plug 'reedes/vim-wordy',    {'on': 'Wordy'}         " fix weasel/passive words
Plug 'preservim/nerdtree'                           " tree view of files
Plug 'reedes/vim-wheel'                             " scroll with C-k/j, keeping cursor pos
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' } " color boxes
Plug 'tpope/vim-fugitive'                           " let's see how long before I remove it
Plug 'jistr/vim-nerdtree-tabs'

"Plug 'dstein64/nvim-scrollview', {'branch': 'main'} " scrollbars!
"Plug 'nanozuki/tabby.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/completion-nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'ggandor/leap.nvim'

call plug#end()

" gah
source ~/etc/nvim/plugged/vim-nerdtree-tabs/nerdtree_plugin/vim-nerdtree-tabs.vim

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
"set relativenumber               " relative line
set list                         " enable listchars (see below)
set tabstop=8                    " show tabs as 8 spaces
set smarttab
set encoding=utf-8               " set UTF-8 encoding
set backspace=indent,eol,start   " backspace through anything
set noincsearch                  " don't autosearch
set inccommand=nosplit           " show preview of substitutions
set wrap                         " wrap long lines, please!
set mouse=a                      " disable the pesky mouse support
set mousehide                    " hide mouse while typing
set scrolloff=3                  " lines to keep above/below cursor when scrolling
set showmatch                    " show matching brackets/parens
set fillchars=eob:\              " remove the annoying tildes at the end of a file
set concealcursor=               " show concealed text as-is when editing line
set signcolumn=yes               " reserve space to avoid jitter

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

nnoremap <Leader>p :bp<CR>
nnoremap <Leader>n :bn<CR>

nnoremap <Leader>S :call SynGroup()<CR>
nnoremap <Leader>C :source $MYVIMRC<CR>
nnoremap <Leader>t :NERDTreeTabsToggle<CR>
nnoremap <Leader><C-S-]> <C-w><C-]><C-w>T
nnoremap <Leader>g :Goyo \| :set nocursorline<CR>

nnoremap <Leader>fb :Telescope buffers<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <Leader>b yypV:!mybib<CR>gq}

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

nmap <C-S-c> "+y
vmap <C-S-c> "+y
nmap <C-S-v> "+p
inoremap <C-S-v> <c-r>+
cnoremap <C-S-v> <c-r>+

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
	autocmd FileType text,typst,markdown,gmi setlocal textwidth=80
augroup END

" enable spelling for my mail (with aerc), markdown/text, and gemini pages
augroup spelling
	autocmd!
	autocmd FileType text,mail,markdown,gmi setlocal spell
augroup END

" misc settings
augroup misc
	autocmd!
	autocmd FileType text,mail,markdown setlocal colorcolumn=
	"autocmd FileType markdown           setlocal conceallevel=0
augroup end


" }}}
""" plugin-specific settings
" {{{

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

" fidget
lua <<EOF
require("fidget").setup {
    -- options
}
EOF


" rust lsp
:lua << EOF
    local lspconfig = require'lspconfig'
    lspconfig.rust_analyzer.setup({
    	settings = {
	    ['rust_analyzer'] = {
	        diagnostics = { enable = true; }
	    }
	},
        on_attach = function(client, bufnr)
                --vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
    })
EOF


" zig lsp

":lua << EOF
"    local lspconfig = require('lspconfig')
"
"    local on_attach = function(_, bufnr)
"        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
"        require('completion').on_attach()
"    end
"
"    local servers = {'zls'}
"    for _, lsp in ipairs(servers) do
"        lspconfig[lsp].setup {
"            on_attach = on_attach,
"        }
"    end
"EOF

"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Enable completions as you type
let g:completion_enable_auto_popup = 1

" Lua plugins

let s:lua_packagepath =  expand("<sfile>:h:r")
exe "lua package.path = package.path .. ';" . s:lua_packagepath . "/plugin/?.lua'"

exe "lua package.loaded.rename = nil"
command! -nargs=0 Rename lua require("rename").rename()
nnoremap <Leader>r :Rename<CR>

" Leap.nvim
lua require('leap').add_default_mappings()

" Hexinokase
let g:Hexokinase_highlighters = ['virtual']

" NERDTree
let NERDTreeHijackNetrw=1

" Neovide
if exists("g:neovide")
	set guifont=Fira\ Code:h7
	let g:neovide_padding_top = 16
	let g:neovide_padding_bottom = 16
	let g:neovide_padding_right = 16
	let g:neovide_padding_left = 16
	let g:neovide_hide_mouse_when_typing = v:true
	let g:neovide_confirm_quit = v:true
	let g:neovide_cursor_animation_length = 0.09
endif


" }}}

""" colorscheme
" {{{

"colorscheme default
colorscheme plain
" Actually light, I mixed some stuff up in my theme file
set background=dark

" }}}

source ~/.cache/wal/colors.vim
source ~/etc/nvim/plugin/tabline.vim
source ~/etc/nvim/plugin/statusbar.vim
source ~/etc/nvim/plugin/ligatures.vim
source ~/etc/nvim/plugin/z/z.vim
