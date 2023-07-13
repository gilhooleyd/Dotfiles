set nocompatible              " be iMproved, required

set fillchars+=vert:│

if $FUCHSIA_DIR != ""
source ~/fuchsia/scripts/vim/fuchsia.vim
endif

set mouse=a
set clipboard=unnamedplus   " using system clipboard
set ttyfast                 " Speed up scrolling in Vim

set colorcolumn=100
highlight ColorColumn ctermbg=7

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VUNDLE OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off                  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'vimwiki/vimwiki'
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-dispatch'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'
Plugin 'vim-airline/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'idanarye/vim-merginal'
Plugin 'arcticicestudio/nord-vim'
Plugin 'preservim/nerdtree'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
set foldmethod=indent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Powerline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts = 1
let g:airline_section_warning = ''
let g:airline_section_error = ''

let g:airline_section_x = ""
let g:airline_section_y = ""
let g:airline_section_z = ""

command TagMake :!make_tags<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tags+=~/fuchsia/zircon/tags,~/fuchsia/garnet/tags
set tags+=~/fuchsia/out/default.zircon/gen/tags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Leader Commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <C-b> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen=1

let mapleader = ","
let g:mapleader = ","

map <C-p> :GFiles<cr>

" YCM
map <leader>yy :YcmCompleter goto<cr>
map <leader>yt :YcmCompleter RefactorRename 

map <Leader>l <Plug>(easymotion-overwin-line)
map <Leader>w <Plug>(easymotion-overwin-w)
map <Leader>co :cwindow<cr>
map <Leader>cl :cclose<cr>
map <Leader>gw viwy :grep -R <C-R>" .

map <leader>ss :setlocal spell!<cr>


map <leader>sv :vsplit <cr>
map <leader>sh :split  <cr>
map <leader>x  :x <cr>
map <leader>w  :w <cr>

map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

map <leader>ee :Ex<cr>
map <leader>ev :Vex<cr>
map <leader>es :Sex<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Make keybindings
map <leader>r :Dispatch fx reboot<cr>
map <leader>m :Dispatch cmake --build build/ -j 10<cr>
map <leader>d :Dispatch 

" Fuzzy Finding keybindings
map <leader>ft :Tags <cr>
map <leader>ff :Files <cr>
map <leader>fb :Buffers <cr>
map <leader>fg :Ag <cr>
map <leader>fm :Marks <cr>

" Git keybindings
map <leader>gg :Gstatus <cr>
map <leader>gl :Glog -10 -- % <cr>
map <leader>gv :Gblame <cr>
map <leader>gb :Merginal <cr>

" Fast saving
nmap <leader>w :w!<cr>

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tl :tabnext <cr>
map <leader>th :tabprev <cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread


" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Turn on the WiLd menu
set wildmenu

" have completion menu act like bash
set wildmode=longest,list

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Set line numbers
set nu

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

hi CursorLineNR cterm=bold
augroup CLNRSet
        autocmd! ColorScheme * hi CursorLineNR cterm=bold
augroup END

augroup nord-theme-overrides
  autocmd!
  " Use 'nord7' as foreground color for Vim comment titles.
  autocmd ColorScheme nord highlight Comment ctermfg=6
  autocmd ColorScheme nord highlight Folded ctermfg=15 ctermbg=0
  autocmd ColorScheme nord highlight TabLineSel ctermfg=15 ctermbg=0 cterm=Bold,None
  autocmd ColorScheme nord highlight TabLine ctermfg=4 ctermbg=0
  autocmd ColorScheme nord highlight TabLineFill cterm=Bold,None ctermfg=15 ctermbg=4

augroup END

hi TabLineFill cterm=Bold,None ctermfg=15 ctermbg=4
hi Comment ctermfg=8

colorscheme nord

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

set fillchars+=vert:│

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr

set ai "Auto indent
set cindent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk


" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

" Copy the 'a' register into our clipboard
function Yankandcopy(event)
  if a:event.regname == "a"
    call system("nc localhost 8001", a:event.regcontents)
  endif
endfunction

" Any time there's a clipboard copy call Yankandcopy
augroup wayland_clipboard
  au!
  au TextYankPost * call Yankandcopy(v:event)
augroup END

" Remap the default yanks and paste to the 'a' register.
noremap  y "ay
noremap  Y "aY
noremap  x "aX
noremap  X "aX
noremap  p "ap
noremap  P "aP
vnoremap y "ay
vnoremap Y "aY
vnoremap x "aX
vnoremap X "aX
vnoremap p "ap
vnoremap P "aP

" Highlight extra whitespace
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhitespace /\s\+$/
highlight ExtraWhitespace ctermbg=red guibg=red
