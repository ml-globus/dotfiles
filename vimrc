set nocompatible   " Disable backwards compatibility
" Notes on tracking down inexplicable behavior, e.g. when a new Vim version
" adds a default plugin which interferes with something:
"
" `:scriptnames` lists all loaded plugins and vimrcs, including everything included by default.
" `:function` lists all functions
" `:function <func` shows details about `<func>`
" `:set runtimepath` to track down where it came from in the first place.
" `:set all` shows current options except terminal.
" `:set` shows all options that differ from their default value.
" `:verbose set <thing>?` shows where <thing> was set
" <F10> to see highlight group word under cursor belongs to -- for debugging
" colorshemes and syntax files:
nmap <silent> <F10>   :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Vundle package manager setup:
filetype off                                " Required by Vundle, re-enabled later
set runtimepath+=~/.vim/bundle/Vundle.vim   " Vundle needs to be git cloned here
call vundle#begin('~/.vim/bundle')          " Path where Vundle installs plugins
Plugin 'VundleVim/Vundle.vim'               " Let Vundle manage Vundle, required

" Show git diff in sign column ("gutter"):
Plugin 'airblade/vim-gitgutter'
" `updatetime` is the number of milliseconds with no keypresses before vim writes to
" swap file. Also affects how quickly vim-gitgutter notices changes.
set updatetime=100
" Max number of changes can be limited for performance:
"let g:gitgutter_max_signs = 500  " 500 is default

" Consistent navigation between vim and tmux splits using CTRL-<hjkl>
Plugin 'christoomey/vim-tmux-navigator'

" Fancy replacement for builtin matchit plugin. Additional config for matches below.
" By default it shows off-screen matches in the status bar. Disable:
let g:matchup_matchparen_offscreen = {'method': 'status_manual'}
" Adds a small delay so it's not constantly recomputing when moving cursor,
" for performance reasons:
let g:matchup_matchparen_deferred = 1
let g:matchup_matchparen_deferred_show_delay = 25
Plugin 'andymass/vim-matchup'

" Colorsheme packs:
Plugin 'danilo-augusto/vim-afterglow'

call vundle#end()   " Required -- all Plugins must be added before this line
filetype on         " Re-enable filetype detection; syntax highlighting, options, etc.
                    " (all `FileType` configs must come after this)
filetype plugin on  " Load plugins for specific filetypes
filetype indent on  " Load filetype specific indent rules

syntax on           " Enable syntax highlighting

let g:afterglow_inherit_background=1 " Make afterglow play nicely with terminal/tmux
colorscheme afterglow

set expandtab       " Expand <Tab> to spaces in insert mode. CTRL-V<Tab> forces real tab
set tabstop=4       " <Tab> == 4 spaces
set softtabstop=4   " Treat 4 spaces as a tab for BACKSPACE and DELETE
set autoindent      " Auto-indent reasonably for filetypes without specific indentation rules

set backspace=indent,eol,start " Make backspace behave normally in insert mode

set wrap linebreak          " Wrap long lines at word boundries
set whichwrap+=<,>,h,l,[,]  " Wrap using cursor and h / l keys:
" Make up/down/home/end use display line instead of physical line:
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

set number          " Show line number
set laststatus=2    " Always show statusline, even with just one window
set showtabline=0   " Hide tab page label line

set incsearch       " Incremental search
set hlsearch        " Highligt matches
set ignorecase      " Case-insensitive search...
set smartcase       " ...except when mixing upper and lower case
nnoremap * g*       " Match partial when using `*`, so `foo` matches `foobar`
nnoremap # g#       " Like `*` but backwards
" Search result styling:
hi clear Search     " Disable whatever the current colorscheme did
hi Search ctermbg=black guibg=black cterm=bold gui=bold

" Highlight words matching word under cursor:
"autocmd CursorMoved * silent! exe printf('match IncSearch /\<%s\>/', expand('<cword>'))

" Matching -- character/word group you can jump between with `%`:
"set matchpairs=(:),{:},[:],<:> " Not needed with vim-matchup
" Italicize matched words:
hi clear MatchParen
hi MatchParen cterm=italic gui=italic
" Adds rudimentary but janky support for matching Python syntax (which
" vim-matchup and seemingly every other matching plugin doesn't support).
" Details here: https://github.com/andymass/vim-matchup/issues/68
" Groups are comma-separated, terms in the group are colon separated.
autocmd FileType python let b:match_words = '^\(\s*\)\<if\>:^\1\<elif\>:^\1\<else\>,^\(\s*\)\<try\>:^\1\<except\>:^\1\<else\>'

" Highlight trailing whitespace, but not in insert mode:
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" Trim trailing whitespace for whole file:
function! TrimWhiteSpace()
            %s/\s\+$//e
endfunction

set mouse=n         " Use mouse, but only in normal mode.
set ttymouse=sgr    " Needed for mouse to work with wide (>220 cols) terminals.

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

" Make Y behave like other capitals -- yank rest of line:
map Y y$
" P pastes to new line, even if register doesn't have a newline char:
nmap P :pu<CR>

" Set up statusline:
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
"set statusline+=%{GitStatus()}

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{GitStatus()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ " Trailing whitespace really needed...
