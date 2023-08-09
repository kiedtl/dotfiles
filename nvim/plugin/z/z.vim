" Title:        kiedtl's zettelkasten utils
" Description:  Various utils that I use to keep a zettelkasten
" Last Change:  27 July 2023
" Maintainer:   kiedtl

" if exists("g:loaded_exampleplugin")
"     finish
" endif
" let g:loaded_exampleplugin = 1

let s:lua_packagepath =  expand("<sfile>:h:r")
exe "lua package.path = package.path .. ';" . s:lua_packagepath . "/?.lua'"

exe "lua package.loaded.zet = nil"

" Defines a package path for Lua. This facilitates importing the
" Lua modules from the plugin's dependency directory.
"let s:lua_deps_loc =  expand("<sfile>:h:r") . "/deps"
"exe "lua package.path = package.path .. ';" . s:lua_deps_loc . "/lua-?/init.lua'"

command! -nargs=0 ZetRename lua require("zet").zet_rename()

nnoremap <Leader>zr :ZetRename<CR>
