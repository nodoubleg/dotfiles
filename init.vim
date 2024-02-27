let g:spacevim_guifont = 'MesloLGSNerdFontComplete-Regular:h14'
"let g:indentLine_faster = 1
syn off
let g:indentLine_enabled = 0
syn on
"set nowrap
set lazyredraw
set clipboard=unnamed
"let g:airline#extensions#whitespace#enabled = 0
let g:spacevim_disabled_plugins=[
    \ ['junegunn/fzf.vim'],
    \ ['Yggdroot/indentLine'],
    \ ['easymotion/vim-easymotion'],
    \ ]

" emacs-like beginning and end of line
map <C-a> <Home>
map <C-e> <End>
" wrap arrow keys across newlines
set whichwrap+=<,>,h,l,[,]
let g:spacevim_relativenumber = 0
set norelativenumber
func! myspacevim#after() abort
  let g:spacevim_relativenumber = 0
  set norelativenumber
endf

