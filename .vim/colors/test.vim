" Vim color file
" Maintainer: Bram Moolenaar <Bram@vim.org>
" Last Change:  2001 Jul 23

" This is the default color scheme.  It doesn't define the Normal
" highlighting, it uses whatever the colors used to be.

" Set 'background' back to the default.  The value can't always be estimated
" and is then guessed.
hi clear Normal guifg=white guibg=#011116
"set bg&


" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

let colors_name = "test"

let s:foreground = "eaeaea"
let s:background = "000000"
let s:selection = "002930"
let s:line = "2a2a2a"
let s:comment = "969896"
let s:red = "d54e53"
let s:orange = "e78c45"
let s:yellow = "e7c547"
let s:green = "b9ca4a"
let s:aqua = "70c0b1"
let s:blue = "7aa6da"
let s:purple = "c397d8"
let s:window = "4d5057"

" vim: sw=2
