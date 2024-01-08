" Configure looks
set background=dark
colorscheme sorbet
syntax on
hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=NONE

" Line cursor in Insert Mode, block cursor everywhere else
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" General config
set number
set nocompatible
filetype on
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

" YAML
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Python
let python_highlist_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python map <buffer> F :set foldmethod=indent<cr>

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f # --- <esc>a
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 
