" Configure looks
set background=dark
try
    colorscheme sorbet
catch
endtry
syntax on
hi Normal guibg=NONE ctermbg=NONE
hi NonText ctermbg=NONE
set foldcolumn=1

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
set hlsearch
set ignorecase
set smartcase
set incsearch
set magic
set showmatch
set regexpengine=0
set cmdheight=1

" Autoread file when changed from the outside
set autoread
au FocusGained,BufEnter * silent! checktime

" Set extra options when in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

" Use spaces instead of tabs. 1 tab == 4 spaces
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Status line
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" Turn off sound
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" :W sudo saves file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Configure backspace so it acts as it should
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"Remember last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set pastetoggle=<F3>

" YAML
if has("autocmd")
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
endif

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

""""""""""""""""""""
" => Helper functions
""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction
