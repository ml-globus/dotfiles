" WISHLIST:
" - Auto-fill comments up to one blank line, and remove trailing blank lines
"   after that. E.g, typing: "# Comment<CR><CR>More comments<CR><CR><CR>"
"   would result in:
"       # Comment
"       #
"       # More comments


filetype off
execute pathogen#infect()

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')

" " let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Consistent navigation between vim and tmux splits:
Plugin 'christoomey/vim-tmux-navigator'

" Put Python <class>.<method> in statusline
" TODO: get this to work with vim-airline
Plugin 'mgedmin/pythonhelper.vim'
set statusline=%<%f\ %h%m%r\ %1*%{TagInStatusLine()}%*%=%-14.(%l,%c%V%)\ %P

" ALE - Async (Python) Lint Engine -- requires VIM 8.0
Plugin 'w0rp/ale'
nmap <silent> <C-n> <Plug>(ale_next_wrap)
nmap <silent> <C-m> <Plug>(ale_previous_wrap)

Plugin 'vim-airline/vim-airline'

" Jedi autocompletion -- assumes jedi has been pip installed
" Use this to get virtualenvs working until it gets resolved for real:
" https://github.com/davidhalter/jedi/pull/829/commits/2ca6dd4a98a9f420d5c547c08aa1f9dfd6bd9801
Plugin 'davidhalter/jedi-vim'
let g:jedi#use_tabs_not_buffers = 1

" Bash-like tab completion:
Plugin 'ervandew/supertab'

" Indentation based selections
Plugin 'michaeljsmith/vim-indent-object'

set nocompatible	" Disable backwards compatibility

set expandtab
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
highlight clear SignColumn

" Use mouse, but only in normal mode. Yay!
set mouse=n
" Make split resizing work in tmux
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

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

set showtabline=0	" Hide tab page label line

" Fancy % matching
filetype plugin on
runtime macros/matchit.vim

" Turn on omni completion
filetype plugin indent on
set ofu=syntaxcomplete#Complete

" Highlight word under cursor.
"autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))

" Make Y behave like other capitals
map Y y$

" Treat _ as a word-boundry, but only for 'w' so it doesn't mess up syntax
" highlighting/auto-complete/etc. 'noremap' applies it non-recursively (so 'w'
" works as normal inside the function) to all non-insert modes, so it also
" works as a motion-modifier. 
" TODO: Apply this to other motion commands as well
function! UnderscoreWord()
    set iskeyword-=_
    normal! w
    set iskeyword+=_
endfunc
noremap <silent> w :call UnderscoreWord()<cr>

" P pastes to new line
nmap P :pu<CR>

" Cmd+j un-joins line
" TODO: should also trim trailing whitespace
nnoremap <D-j> i<CR><Esc>

" Ctrl-V and Cmd-V pastes from system clipboard, without needing to
" set paste/set nopaste
imap <C-v> ^O"+p
imap <D-v> ^O"+p

" automatically reload vimrc when it's saved
" Suspect this may be causing intermittent hangs
" au BufWritePost .vimrc so ~/.vimrc

" Python specific settings:
" Expand tabs to spaces:
" Folding options:
au FileType python set foldmethod=indent
" Use space to open/close folds:
au FileType python nnoremap <space> za
au FileType python vnoremap <space> zf
au FileType python set foldnestmax=2 "Fold methods but not for-loops/ifs/etc.
set foldlevelstart=99 " Don't fold when first opening a file
" (zR expands all fold in the file, zm closes folds)

let g:pydoc_open_cmd = 'vsplit' " Use vsplit for python_pydoc.vim
autocmd BufWritePre *.py :%s/\s\+$//e " Shave trailing whitespace on write

" YAML settings:
au FileType yaml set tabstop=2
au FileType yaml set softtabstop=2

" HTML/Jinja2 settings
au FileType html set tabstop=2
au FileType html set softtabstop=2
au FileType jinja2 set tabstop=2
au FileType jinja2 set softtabstop=2

" Use undofile
set undodir=~/.vim/undodir
set undofile

" Ctrl+n to toggle between relative and absolute line numbers, default to
" relative
"set relativenumber
"function! NumberToggle()
"  if(&relativenumber == 1)
"    set relativenumber!
"    set number
"  else
"    set relativenumber
"  endif
"endfunc
"nnoremap <C-n> :call NumberToggle()<cr>

" Ctrl+c copies into system clipboard -- works over SSH if X11 forwarding is
" enbabled and the host is running a X11 server with clipboard sync.
vnoremap <C-c> "+y
