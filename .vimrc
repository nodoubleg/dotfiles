set nocompatible               " be iMproved"
" Vundle setup
filetype off                   " required!
filetype indent on
 
  set rtp+=~/.vim/bundle/vundle/
     call vundle#rc()
   
" let Vundle manage Vundle
Bundle 'gmarik/vundle'
filetype plugin indent on
" end vundle setup

Bundle 'airblade/vim-gitgutter'
Bundle 'daviddavis/vim-powerline'

execute pathogen#infect()

syntax on
"colorscheme Tomorrow-Night-Eighties 
colorscheme default
" do indents with space always, with 2 space indent.
set autoindent
set nu
set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2
set smartindent

" Shortcut for opening preview in Marked.app
nnoremap <leader>m :silent !open -a Marked.app '%:p'<cr>

" break-less word wrapping
set wrap
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
set expandtab

" Powerline stuff
set laststatus=2
set encoding=utf-8
set t_Co=256

"let g:Powerline_cache_dir = simplify(expand('<sfile>:p:h') .'/..')

" woo fancy colors
let g:Powerline_symbols = 'fancy'
let g:gitgutter_enabled = 1
let g:gitgutter_signs = 1
let g:gitgutter_sign_column_always = 1
let g:syntastic_puppet_lint_args = "--no-80chars-check"

" aliases
" shortcut for SyntasticCheck
cnoreabbrev <expr> synck ((getcmdtype() is# ':' && getcmdline() is# 'synck')?('SyntasticCheck'):('synck'))
