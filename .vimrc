runtime! debian.vim

"Vim UI"
set nocompatible
syntax on
set showcmd " Show (partial) command in status line.
set showmatch " Show matching brackets.
set ignorecase " Do case insensitive matching
set smartcase " Do smart case matching
set incsearch " highlight as we go
set autowrite " Automatically save before commands like :next and :make
set background=dark
set nostartofline "leave my cursor where it was
set scrolloff=10 "display 10 lines above and below cursor
set list " we do what to show tabs, to ensure we get them out of my files
set listchars=tab:>-,trail:- " show tabs and trailing whitespace
set hidden " Hide buffers when they are abandoned
set mouse=a "Enable mouse usage (all modes)
set number "Display line numbers on the left
"case insensitive search except when using capital letters"
set ignorecase
set smartcase
" Always display the status line, even if only one window is displayed
set laststatus=2

" Add the g flag to search/replace by default
set gdefault
"
" Centralize backups, swapfiles and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" Don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*

" Respect modeline in files, which allow you to customize vim on a per-file basis
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure

" Highlight current line
set cursorline

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

" Disable error bells, and allow sound
set noerrorbells
set novisualbell

" Don’t show the intro message when starting Vim
set shortmess=atI


"indenting
set autoindent
filetype plugin indent on
set shiftwidth=4
set softtabstop=4
set shiftround " when at 3 spaces, and I hit > ... go to 4, not 5
"switch tabs with spaces
set expandtab

"goto last line when reading a file"
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
   \| exe "normal! g'\"" | endif

"Custom Config"

execute pathogen#infect()

"display limit of 79 chars
set colorcolumn=80

" folding
set foldenable " Turn on folding
set foldmethod=manual " Fold on the indent
set foldlevel=100 " Don't autofold anything (but I can still fold manually)
set foldopen=block,hor,mark,percent,quickfix,tag " what movements open folds

" autocommands
"immediatly source changes to vimrc
autocmd bufwritepost .vimrc source $MYVIMRC

"mappings"
let mapleader = ','

""""" normal mode """""
"
" Save a file as root (,W)
nnoremap <leader>W :w !sudo tee % > /dev/null<CR>

nnoremap <CR> G

" make executing commands easier
nnoremap ; :
nnoremap : ;

vnoremap ; :
vnoremap : ;


"map s and S to add a single char for insert mode"
:nnoremap <silent> s :exec "normal i".nr2char(getchar())."\e"<CR>
:nnoremap <silent> S :exec "normal a".nr2char(getchar())."\e"<CR>

"swap two words
nnoremap gw mz"zdiwdwep"zp`z

"copy to clipboard
nnoremap <leader>y :%y+<CR>
vnoremap <leader>y "+y

"select last pasted text"
nnoremap gp `[v`]

"insert semicolon at end of line
nnoremap <C-e> mzA;<Esc>`z

"tab autocompletion"
inoremap <tab> <c-N>
inoremap <c-N> <tab>

"replace <c-a> with for screen"
nnoremap <leader>inc <c-a>

"make editing vimrc easy
nnoremap <leader>vimrc :tabe ~/.vimrc<cr>

"delete trailing whitespace
nnoremap <leader>? :%s/\s\+$//g<cr>

"delete pair of brackets
nnoremap <leader>x %x``x

"delete function
nnoremap <leader>df f{V%d

"format source code
nnoremap <leader>= ggVG=

"buffers
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

"quit and delete buffer
nnoremap <leader>wbd :w<cr> :bd<cr>

"""""  extremely specialized"""""
"hack to fix require statements
vnoremap <leader>req :normal $x^r vEr <cr> A)<Esc> gg/require<cr>$x

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Swap Words"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"get rid of weird quotes copied from textbooks
nnoremap <leader>quotes :%s/’\|‘/'/g<CR>

""""" insert mode """""
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

"don't indent when pasting
set pastetoggle=<c-P>

"Plugins"

"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

"nerdtree
nnoremap <leader>nerd :NERDTree<cr>
set splitright

"syntastic syntax checkers
let g:syntastic_javascript_jshint_exec = '/usr/bin/jshint'
:vmap <leader>x :!tidy -q -i --show-errors 0<CR>

" display all buffers with airine
let g:airline#extensions#tabline#enabled = 1"
