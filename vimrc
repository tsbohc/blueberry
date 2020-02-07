"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |

" -------------------------------------------------
"   plug
" -------------------------------------------------

" autoinstall
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" package set up
if has('nvim')
  call plug#begin('~/.vim/bundle')

  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  Plug 'terryma/vim-multiple-cursors', { 'on': [] }
  Plug 'morhetz/gruvbox'
  Plug 'Yggdroot/indentline'
  Plug 'junegunn/goyo.vim'
  "Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'

  augroup load_us_ycm
    autocmd!
    autocmd InsertEnter * call plug#load('vim-multiple-cursors')
      \| autocmd! load_us_ycm
  augroup END

  call plug#end()
endif

" -------------------------------------------------
"   user settings
" -------------------------------------------------

"let g:UltiSnipsExpandTrigger="<CR>"
"let g:UltiSnipsExpandTrigger="<c-b>"

let g:indentLine_char = '│'

" rendering
set encoding=utf-8
set nocompatible
set ttyfast
set synmaxcol=256
"set background=dark

" mode switch delays
set ttimeout
set ttimeoutlen=30
set timeoutlen=3000

" gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'
let g:gruvbox_italic = '1'
let g:gruvbox_bold = '0'

" syntax highlighting
colorscheme gruvbox
set t_Co=256
set termguicolors
"hi Normal ctermbg=none guibg=none

filetype indent on
set number relativenumber " relative numbers
set cursorline " highlight current line
set showmatch " hl matching [{(s
"hi MatchParen cterm=bold ctermbg=darkgray ctermfg=white

" invisibles
exec "set listchars=trail:␣"
",eol:⌟"

set list

" whitespace
set wrap
set scrolloff=10
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" search
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " case-insensitive search
set smartcase " case-sensitive if search contains uppercase
set showmatch
nnoremap // :noh<return>

" clipboard woes, default vim
set clipboard=unnamedplus " systemwide
vmap <leader>y :w! /tmp/vitmp<CR>
nmap <leader>p :r! cat /tmp/vitmp<CR>

" disable new line comment
autocmd FileType * setlocal formatoptions-=cro

" -------------------------------------------------
"   vim magic
" -------------------------------------------------

" recompile suckless programs automagically
autocmd BufWritePost config.h,config.def.h !sudo make install

" run xrdb whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

" write a function that handles swapfiles automagically

" auto-update current buffer if it's been changed from somewhere else
set autoread
augroup autoRead
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END

" -------------------------------------------------
"   keymaps
" -------------------------------------------------

" hardmode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <PageUp> <nop>
noremap <PageDown> <nop>

inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <PageUp> <nop>
inoremap <PageDown> <nop>

" vi-line movement
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" -------------------------------------------------
"   filetype specifics
" -------------------------------------------------

" python
au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

" -------------------------------------------------
"   status line
" -------------------------------------------------

let g:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'VLINE',
    \ '^V' : 'VBLOCK',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V·Replace',
    \ 'c'  : 'COMMAND',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal'
    \ }

" not sure why this is here, because the defaults are overwritten below without any checks
" the stlcolor9fg etc are too cryptic, and since the colors are conventional (insert = green) i should just rename them
" should implement a check that looks for a hex value, and if it doesn't find it, grabs term colors

" cterm color definitions
" mode name
"hi User1 ctermbg=4 ctermfg=bg cterm=bold
"" mode arrow separator
"hi User2 ctermbg=8 ctermfg=4
"" file name
"hi User3 ctermbg=8 ctermfg=fg
"" gray to black
"hi User4 ctermbg=bg ctermfg=8
"" gray to white
"hi User5 ctermbg=8 ctermfg=fg
"" black on white
"hi User6 ctermbg=fg ctermfg=bg

" col.sh's autogenerated config
source ~/blueberry/vim/colors/colman.vim

" links User1 and User2 (%1 & %2) to predefined #color values
function! ChangeStatuslineColor()
"  if mode() =~# '\v(n|c)' " command and others now default to red
  if mode() == 'n' " blue
"   hi User1 ctermbg=12
"   hi User2 ctermfg=12
    hi! link User1 stlcolor12bg
    hi! link User2 stlcolor12fg
  elseif (mode() =~# '\v(v|V)' || ModeCurrent() == 'VBLOCK') " orange
"   hi User1 ctermbg=11
"   hi User2 ctermfg=11
    hi! link User1 stlcolor11bg
    hi! link User2 stlcolor11fg
  elseif mode() == 'i' " green
"   hi User1 ctermbg=10
"   hi User2 ctermfg=10
    hi! link User1 stlcolor10bg
    hi! link User2 stlcolor10fg
  else " red
"   hi User1 ctermbg=9
"   hi User2 ctermfg=9
    hi! link User1 stlcolor9bg
    hi! link User2 stlcolor9fg
  endif
  redrawstatus
  return ''
endfunction

function! ModeCurrent() abort
    let l:modecurrent = mode()
    " abort -> function will abort soon as error detected
    " use get() -> fails safely, since ^V doesn't seem to register
    " 3rd arg is used when return of mode() == 0, which is case with ^V
    " thus, ^V fails -> returns 0 -> replaced with 'V Block'
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'VBLOCK'))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

function! StatusLineFileName()
    let full_file_path = expand('%')
    if full_file_path == ''
      let full_file_path = '[new]'
    else
      let full_file_path = fnamemodify(expand('%'), ':~')
    endif
    return strlen(full_file_path) < winwidth(0)*0.55 ? full_file_path : expand('%f')
endfunction

function! StatusLineFileType()
    return &filetype
endfunction

function! StatusLineModified()
    return &modified ? ' + ' : ''
endfunction

function! StatusLineReadonly()
    return &readonly ? ' readonly ' : ''
endfunction

set noshowmode
set laststatus=2
set statusline=

" left side
set statusline+=%{ChangeStatuslineColor()} " automagically set mode color
set statusline+=%1*\ %{ModeCurrent()}\ %2* " [1]_mode_[2]>
set statusline+=%3*\ %{StatusLineFileName()}\  " [3]_filename_
set statusline+=%{StatusLineReadonly()}
set statusline+=%{StatusLineModified()}
set statusline+=%4*
" right side
set statusline+=%=
set statusline+=%{StatusLineFileType()} " filetype
set statusline+=\ %4*%3*\ %p%% " _[4]<[3]_percentage
set statusline+=\ %5*%6*\ %l:%c\  " _[5]<[6]_line:column_
