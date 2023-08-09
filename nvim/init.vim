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

"Plug 'dstein64/nvim-scrollview', {'branch': 'main'} " scrollbars!

Plug 'nanozuki/tabby.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'kyazdani42/nvim-web-devicons'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }

Plug 'ggandor/leap.nvim'

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
"set relativenumber               " relative line
set list                         " enable listchars (see below)
set tabstop=8                    " show tabs as 8 spaces
set smarttab
set encoding=utf-8               " set UTF-8 encoding
set backspace=indent,eol,start   " backspace through anything
set noincsearch                  " don't autosearch
set inccommand=nosplit           " show preview of substitutions
set wrap                         " wrap long lines, please!
set mouse=                       " disable the pesky mouse support
set mousehide                    " hide mouse while typing
set scrolloff=3                  " lines to keep above/below cursor when scrolling
set showmatch                    " show matching brackets/parens
set fillchars=eob:\              " remove the annoying tildes at the end of a file
set concealcursor=               " show concealed text as-is when editing line

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
nnoremap <Leader>d :NERDTreeToggleVCS<CR>
nnoremap <Leader><C-S-]> <C-w><C-]><C-w>T
nnoremap <Leader>fb :Telescope buffers<CR>

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
	autocmd FileType text,mail,markdown,gmi setlocal textwidth=80
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
augroup end


" }}}
""" plugin-specific settings
" {{{

let g:indentLine_setColors = 1
let g:indentLine_char      = '┆'
let g:ft_man_open_mode     = 'tab'

" zig lsp

:lua << EOF
    local lspconfig = require('lspconfig')

    local on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        require('completion').on_attach()
    end

    local servers = {'zls'}
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
        }
    end
EOF

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Enable completions as you type
let g:completion_enable_auto_popup = 1

" tabby.nvim

lua <<EOF
local filename = require('tabby.module.filename')
local colors = require('tabby.module.colors')
local tab = require('tabby.tab')
local util = require('tabby.util')

local hl_head = 'TabLineSel' --{ fg = colors.black(), bg = colors.red(), style = 'italic' }
local hl_tabline = 'TabLine'
local hl_tabline_sel = 'TabLineSel' --{ fg = colors.black(), bg = colors.magenta(), style = 'bold' }
local hl_tabline_fill = 'TabLineFill'

local filename = require('tabby.filename')

local cwd = function()
  return ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
end

local function tabname(tabid, active)
  local icon = active and '' or ''
  -- local number = vim.api.nvim_tabpage_get_number(tabid)
  local name = util.get_tab_name(tabid)
  return string.format(' %s %s ', icon, name)
  -- return string.format(' %s %d ', icon, number)
end

local line = {
    hl = hl_tabline_fill,
    layout = 'active_wins_at_tail',
    head = {
        { '', hl = hl_tabline_fill },
        { cwd, hl = hl_head },
        { ' ', hl = hl_tabline_fill },
    },
    active_tab = {
      label = function(tabid)
          return {
            tabname(tabid, true),
            hl = hl_tabline_sel,
          }
        end,
	left_sep = { '', hl = hl_tabline_fill },
	right_sep = { ' ', hl = hl_tabline_fill },
    },
    inactive_tab = {
        label = function(tabid)
          return {
            tabname(tabid),
            hl = hl_tabline,
          }
        end,
        left_sep = { '', hl = "user7" },
        right_sep = { ' ', hl = "user7" },
    },
    top_win = {
        label = function(...) return "" end,
	--function(winid)
          --return {
            --'  ' .. filename.unique(winid) .. ' ',
            --hl = hl_tabline,
          --}
        --end,
	left_sep = { "" }, --{ '', hl = "user7" },
	right_sep = { "" }, --{ ' ', hl = "user7" },
    },
    win = {
        label = function(...) return "" end,
	--function(winid)
          --return {
            --'  ' .. filename.unique(winid) .. ' ',
            --hl = hl_tabline,
          --}
        --end,
        left_sep = "", --{ '', hl = "user7" },
        right_sep = "", --{ ' ', hl = "user7" },
    },
    tail = {
        { '', hl = hl_tabline_fill },
        { '  ', hl = hl_tabline_sel },
        { ' ', hl = hl_tabline_fill },
    },
}

require('tabby').setup({ tabline = line })
EOF

" NERDTree
let NERDTreeHijackNetrw=1
" }}}

" Leap.nvim
lua require('leap').add_default_mappings()

""" colorscheme
" {{{

colorscheme default
colorscheme plain

" }}}

source ~/etc/nvim/plugin/statusbar.vim
source ~/etc/nvim/plugin/ligatures.vim
source ~/etc/nvim/plugin/z/z.vim
