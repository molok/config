" first of all:
set nocompatible

" core:
set backup backupdir=$HOME/.vim/backup
set encoding=utf-8
set fileformats=unix,dos,mac
set history=500
set nofsync
set spelllang=en_us
set spellsuggest=fast,20
set tabpagemax=60
set termencoding=utf-8
set writebackup
set hidden

helptags ~/.vim/doc
set tags+=.,~/.vim/systags,tags;/

" visual:
syntax on
set cmdheight=1
set completeopt=menu,menuone,longest,preview
set cursorline
set laststatus=2
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<,eol:$ "set list
set number
set numberwidth=1
set previewheight=5
set ruler
set scrolloff=10 
set showcmd
set showmatch "brackets
set showmode
"set statusline=%-3.3n\ %f\ %r%#Error#%m%#Statusline#\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ 
set statusline=\(%n\)\ %f\ %r%#Error#%m%*\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ 
set title
set wildchar=<tab>
set wildmenu
set wildmode=longest:full,full
set fillchars=fold:-,diff:-

" search:
set hlsearch
set ignorecase
set incsearch
set smartcase

" navigation:
filetype indent plugin on
set autoindent
set backspace=indent,eol,start
set cinoptions=g0,:0,l1,(0,t0
set expandtab
set formatoptions+=l
"set mouse=a
set mouse=v 
set nowrap
set selection=inclusive
set shiftwidth=4
set smartindent
set softtabstop=4
set splitbelow
set splitright
set tabstop=4
set textwidth=80
"set whichwrap=h,l,<,>,[,]

" no bell, thanks 
set vb
set t_vb=

if has('gui_running')
    color inkpot
    "hi CursorLine guibg=#111111
    "hi StatusLine guifg=#111111 guibg=#000000
    winsize 130 50
    set bg=dark
    set guioptions-=T
"    set guifont=DejaVu\ Sans\ Mono\ 8
    set guifont=Terminus\ 8
    set gcr=n-v-c:block-blinkwait0-blinkon0-blinkoff0
    if has('mac')
        set transparency=3
        hi CursorLine guibg=#2e2e37 gui=NONE
    endif
endif
if has ('mac') || (&term == 'rxvt-unicode' )
    set t_Co=16
endif
if (&term == 'screen-256color-bce' ) || ( &term == 'xterm-color' ) || ( &term == 'screen' ) 
    set t_Co=256
endif
if has ('mac') || (&term == 'screen-256color-bce') || (&term == 'rxvt-unicode' ) || ( &term == 'screen' )
    set bg=light
    colorscheme default

    highlight Comment       ctermfg=darkgray
    highlight Comments      ctermfg=darkgray
    highlight DiffAdd		ctermbg=darkgreen   ctermfg=white
    highlight DiffChange    ctermbg=darkblue    ctermfg=white
    highlight DiffDelete	ctermbg=darkred     ctermfg=white
    highlight DiffText		ctermbg=darkred     ctermfg=white
    highlight Folded		ctermfg=black
    highlight LineNr		ctermfg=darkgray
    highlight MatchParen	ctermbg=cyan        ctermfg=black
    highlight Pmenu		    ctermbg=darkgray
    highlight PmenuSel		ctermbg=darkgray    ctermfg=white   cterm=underline
    highlight Search		ctermfg=black
    highlight ShowMarksHLl  ctermfg=darkyellow       ctermbg=black
    highlight ShowMarksHLm  ctermfg=darkyellow       ctermbg=black
    highlight ShowMarksHLo  ctermfg=darkyellow       ctermbg=black
    highlight ShowMarksHLu  ctermfg=darkyellow       ctermbg=black
    highlight SignColumn    ctermfg=white       ctermbg=black
    highlight SpellBad		ctermfg=white       ctermbg=red
    highlight SpellLocal	ctermfg=yellow      ctermbg=none
    highlight Visual		ctermfg=black
    highlight mailQuoted1	ctermfg=darkgreen
    highlight mailQuoted2	ctermfg=darkyellow
    highlight mailQuoted3	ctermfg=darkmagenta
    highlight mailQuoted4	ctermfg=darkred
    highlight preproc		ctermfg=blue        cterm=bold
    highlight FoldColumn    ctermfg=yellow      ctermbg=black
    highlight Folded        ctermfg=yellow      ctermbg=darkgray
    highlight StatusLine    ctermfg=black       ctermbg=white cterm=none term=none
    highlight StatusLineNC  ctermfg=black       ctermbg=darkgray cterm=none term=none
    highlight VertSplit     ctermbg=darkgray    cterm=none term=none

    " MiniBufExplorer
    highlight MBENormal         ctermfg=darkgray 
    highlight MBEChanged        ctermfg=red
    highlight MBEVisibleNormal  ctermfg=white
    highlight MBEVisibleChanged ctermfg=darkyellow
endif

" autocmd:
if has("autocmd")
    au FileType mail setlocal spell
    au FileType mail,human set formatoptions+=t textwidth=72
    au FileType cvs setlocal spell
    au BufReadPost * if line("'\"")>0 && line("'\"")<=line("$")|exe "normal g`\""|endif
    au BufRead,BufNewFile *PKGBUILD* setlocal ft=PKGBUILD
    au BufRead,BufNewFile *PKGBUILD* iab Maintainer: Maintainer: Alessio 'molok' Bolognino <CHANGEME!@gmail.com>
    au BufRead,BufNewFile *PKGBUILD* iab Contributor: Contributor: Alessio 'molok' Bolognino <CHANGEME!@gmail.com>
    au BufRead,BufNewFile *themolok.netsons.org_* setlocal ft=html
    au BufReadPost /tmp/crontab.* set backupcopy=yes
    au BufRead,BufNewFile * iab STARTCUT ------------8<-------------------8<-------------------8<---------------
    au BufRead,BufNewFile * iab ENDCUT ----------->8------------------->8------------------->8----------------

    au BufRead,BufNewFile *.mkd setlocal ft=mkd
    au BufRead,BufNewFile *.mkd set ai formatoptions=tcroqn2 comments=n:>
endif

" mappings:
map Q :q
map :Q :q
map q: :q
map :W :w
" clears the current search (without the need of :set nohls)
map //  :nohlsearch<CR>
" scroll up/down without moving the cursor
map <C-K> 1<C-U>
map <C-J> 1<C-D>

" marks stuff:
map á 'a
map ć 'c
map é 'e
map í 'i
map ó 'o
map ŕ 'r
map ú 'u
map ý 'y
map ź 'z

" Capitalize!
if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif



" close brackets automagically
"inoremap ( ()<ESC>:let leavechar=")"<CR>i
"inoremap { {}<ESC>:let leavechar="}"<CR>i
"inoremap [ []<ESC>:let leavechar="]"<CR>i
"inoremap < <><ESC>:let leavechar=">"<CR>i
"imap <C-j> <ESC>:exec "normal f" . leavechar<CR>a 

" plugins options:

" HTML.vim
let g:do_xhtml_mappings = 'yes'
let g:html_tag_case     = 'lowercase'

" Project
let g:proj_flags        = "ibmstg"
let g:proj_window_width = 35

" Showmarks off by default (toggle with <leader>mt )
let g:showmarks_enable    = 0
let g:showmarks_textlower = "\t "
let g:showmarks_textupper = "\t "
let g:showmarks_textother = "\t "
" MiniBufExplorer
let g:miniBufExplSplitBelow=0

"TagList
"let Tlist_Display_Tag_Scope = 1 "ugh...
let g:Tlist_Display_Prototype    = 1
let g:Tlist_Use_Right_Window     = 1
let g:Tlist_Exit_OnlyWindow      = 1
let g:Tlist_Enable_Fold_Column   = 0
let g:Tlist_Sort_Type            = "name"
let g:Tlist_Compact_Format       = 0
let g:Tlist_File_Fold_Auto_Close = 0
let g:Tlist_WinWidth             = 50
"
" LaTeX-Suite
let g:tex_flavor='latex'
"let g:Tex_CompileRule_pdf
"let Tex_ViewRuleComplete_pdf = '/usr/bin/open -a Preview $*.pdf'

" EnhancedCommentify
let g:EnhCommentifyPretty = 'Yes'
let g:EnhCommentifyRespectIndent = 'Yes'
let g:EnhCommentifyUserMode = 'Yes'
