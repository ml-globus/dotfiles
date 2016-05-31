filetype off
execute pathogen#infect()

set nocompatible	" Disable backwards compatibility

set tabstop=4
set shiftwidth=4	" To do block (un)indent using < and >.
set softtabstop=4	" Treat 4 spaces as a tab for BACKSPACE and DELETE
set autoindent
syntax on
set showmatch		" Matching parentheses

set number			" Show line number
set laststatus=2    " Show buffer name in status line

" Backspace behavior in insert mode:
set backspace=indent,eol,start
" Wrap using cursor and h / l keys:
set whichwrap+=<,>,h,l,[,]
" Wrap long lines between words:
set wrap lbr
" Make up/down/home/end use display line instead of physical line.
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
nnoremap <Home> g<Home>
nnoremap <End>  g<End>
vnoremap <Home> g<Home>
vnoremap <End>  g<End>

set incsearch		" Incremental search
set hlsearch		" Highligt matches
set ignorecase 
set smartcase		" Don't ignore when mixing upper and lower case

colorscheme zellner

" Use mouse, but only in normal mode. Yay!
set mouse=n

" Tab completion behavior:
set wildmode=longest,list,full
set wildmenu

" Comment out visual block using ,<comment sign>, uncomment using ,c.
map ,# :s/^/#/<CR>:nohlsearch<CR>
map ,/ :s/^/\/\//<CR>:nohlsearch<CR>
map ,> :s/^/> /<CR>:nohlsearch<CR>
map ," :s/^/\"/<CR>:nohlsearch<CR>
map ,% :s/^/%/<CR>:nohlsearch<CR>
map ,! :s/^/!/<CR>:nohlsearch<CR>
map ,; :s/^/;/<CR>:nohlsearch<CR>
map ,- :s/^/--/<CR>:nohlsearch<CR>
map ,c :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

" Press jj within <timoutlen> ms to exit insert mode. This messes up block commenting though...
"imap jj <Esc>       
"set timeoutlen=200  

set showtabline=0	" Hide tab line

" Turn on omni completion
filetype plugin indent on
set ofu=syntaxcomplete#Complete

" Highlight word under cursor.
autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))

" Make Y behave like other capitals
map Y y$

" automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc



" Python specific settings:
" Expand tabs to spaces:
au FileType python set expandtab
" Folding options:
au FileType python set foldmethod=indent
" Use space to open/close folds:
au FileType python nnoremap <space> za
au FileType python vnoremap <space> zf
au FileType python set foldnestmax=2 "Fold methods but not for-loops/ifs/etc.
set foldlevelstart=99 " Don't fold when first opening a file
" (zR expands all fold in the file, zm closes folds)

" Time before CursorHold event is fired -- lower makes pythonhelper.vim more
" responsive, too low makes everything else horrible...
set updatetime=2000


let g:pydoc_open_cmd = 'vsplit' " Use vsplit for python_pydoc.vim

" YAML settings:
au FileType yaml set expandtab
au FileType yaml set tabstop=2
au FileType yaml set softtabstop=2

" Use undofile
set undodir=~/.vim/undodir
set undofile

" Ctrl+n to toggle between relative and absolute line numbers, default to
" relative
set relativenumber
function! NumberToggle()
  if(&relativenumber == 1)
    set relativenumber! " Started needing this after a vim upgrade, not sure why
    set number
  else
    set relativenumber
  endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>
