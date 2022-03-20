set t_Co=256
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1

set number
syntax on
set nocompatible
filetype off
filetype plugin indent on
set modelines=0
set ruler
set encoding=utf-8
set relativenumber

"Remember last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set pastetoggle=<F3>
