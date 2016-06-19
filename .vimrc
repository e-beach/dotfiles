""runtime! debian.vim

set nocompatible
filetype off
filetype plugin indent on

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'flazz/vim-colorschemes'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-repeat'
Plugin 'pangloss/vim-javascript'
Plugin 'kshenoy/vim-signature'

" let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim'

call vundle#end()

set autoindent
set autowrite " Automatically save before commands like :next and :make
set background=dark
set backupdir=~/.vim/backups " Centralize backups, swapfiles and undo history
set backupskip=/tmp/*, " Don’t create backups when editing files in certain directories
set cursorline " Highlight current line
set directory=~/.vim/swaps
set expandtab
set exrc " Enable per-directory .vimrc files and disable unsafe commands in them
set foldenable " Turn on folding
set foldlevel=100 " Don't autofold anything (but I can still fold manually)
set foldmethod=manual " Fold on the indent
set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds
set gdefault " Add the g flag to search/replace by default
set hidden " Hide buffers when they are abandoned
set ignorecase "case insensitive search except when using capital letters"
set incsearch " highlight as we go
set laststatus=2 " Always display the status line, even if only one window is displayed
set list
set listchars=tab:>-,trail:- " show tabs and trailing whitespace
set modeline " Respect modeline in files, which allow you to customize vim on a per-file basis
set modelines=4
set mouse=a "Enable mouse usage (all modes)
set noerrorbells " Disable error bells, and allow sound
set nostartofline "leave my cursor where it was
set novisualbell
set number "Display line numbers on the left
set relativenumber
set scrolloff=10 "display 10 lines above and below cursor
set secure
set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
set shiftwidth=4
set shortmess=atI " Don’t show the intro message when starting Vim
set splitright " vertical split new buffers on the right"
set showcmd " Show (partial) command in status line.
set showmatch " Show matching brackets.
set smartcase " Do smart case matching
set softtabstop=4
syntax on

if exists("&undodir")
    set undodir=~/.vim/undo
endif

autocmd bufreadpost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif "goto last line when reading a file"
autocmd bufwritepost .vimrc source $MYVIMRC "immediatly source changes to vimrc

""""""""""""""""""""""""""""""""
""""""""""""MAPPINGS""""""""""""
""""""""""""""""""""""""""""""""

let mapleader = ','

nnoremap <CR> G

"swap two words
nnoremap gw mz"zdiwdwep"zp`z

"tab autocompletion"
inoremap <tab> <c-N>
inoremap <c-N> <tab>
"
"delete pair of brackets
nnoremap <leader>x %x``x

"delete function call
nmap dsf ds)db

"delete function
nnoremap <leader>df f{V%d

"format source code
nnoremap <leader>= ggVG=

"select last pasted text"
nnoremap gp `[v`]

"copy to clipboard
nnoremap <leader>y :%y+<CR>
vnoremap <leader>y "+y

"insert semicolon at end of line
nnoremap <C-e> mzA;<Esc>`z

"replace <c-a> with as screen uses c-a "
nnoremap <leader>inc <c-a>

"delete trailing whitespace
nnoremap <leader>? :%s/\s\+$//g<cr>
"
" Save a file as root (,W)"
nnoremap <leader>W :w !sudo tee % > /dev/null<CR>

"I cant use my mouse to resize windows during screen session"
nnoremap <leader>+ :vertical resize

"make editing vimrc easy
nnoremap <leader>vimrc :tabe ~/.vimrc<cr>

"buffers
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
"delete current buffer"
nnoremap <silent> ]d :bp\|bd #<CR>

"navigate tabs"
nnoremap <up> :tabn<CR>
nnoremap <down> :tabp<CR>

"resize splits"
nnoremap <left> <c-w>-
nnoremap <right> <c-w>+
nnoremap <c-G> <c-w><
nnoremap <c-H> <c-w>>


set pastetoggle=<c-P> "don't indent when pasting

"map s and S to add a single char for insert mode"
nnoremap <silent> s :exec "normal i".nr2char(getchar())."\e"<CR>
nnoremap <silent> S :exec "normal a".nr2char(getchar())."\e"<CR>


"""""""""""""""""
"Swap Words"
"""""""""""""""""

function! Mirror(dict)
    for [key, value] in items(a:dict)
        let a:dict[value] = key
    endfor
    return a:dict
endfunction

function! S(number)
    return submatch(a:number)
endfunction

function! AddTags(list)
    return map(a:list, '"<" . v:val . ">"')
endfunction

function! SwapWords(dict, ...)
    let words = keys(a:dict) + values(a:dict)
    let words = map(words, 'escape(v:val, "|")')
    if(a:0 == 1)
        let delimiter = a:1
    else
        let delimiter = '/'
    endif
    let pattern = '\v(' . join(AddTags(words), '|') . ')'
    exe "'<,'>s" . delimiter . pattern . delimiter
                \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
                \ . delimiter . 'g'
endfunction

vnoremap <leader>swap <Esc>:call SwapWords({'':''})<Left><Left><Left><Left><Left><Left>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""" insert mode """""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

inoremap <C-k> <Esc>O
inoremap <C-l> <Right>
inoremap <C-h> <Left>

" use fj or jf for escape in every mode
inoremap fj <Esc>
inoremap jf <Esc>
vnoremap fj <Esc>

" make brackets, parentheses, and quotes auto-gen their mates
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap " ""<Left>
inoremap ' ''<Left>


""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Plugins"
""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists("g:didSyntastic")
    "syntastic goes freaking shitballs if you load it twice"

    let g:didSyntastic = "true"

    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*

    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 1
    let g:syntastic_javascript_jshint_exec = '/usr/bin/jshint'
endif

let g:NERDTreeWinSize = 20
nnoremap <leader>nerd :NERDTree<cr>

" display all buffers with airine
let g:airline#extensions#tabline#enabled = 1"

colorscheme busybee
