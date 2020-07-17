"        .
"  __   __)
" (. | /o ______  __  _.
"    |/<_/ / / <_/ (_(__
"    |

" -------------------------------------------------
"{{{ plug

" boostrap plug
"if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
"  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
"    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"endif

" FIXME MOVE FONT CHECK TO STATUSLINE SCRIPT

if has('nvim')
  call plug#begin('~/.vim/bundle')

  " general
  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'

  " coding
  Plug 'Yggdroot/indentline'
  Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
  "Plug 'terryma/vim-multiple-cursors', { 'on': [] }

  " latex
  Plug 'lervag/vimtex'

  " writing
  Plug 'dbmrq/vim-ditto'
  Plug 'ron89/thesaurus_query.vim'
  Plug 'reedes/vim-lexical'

  " style
  Plug 'morhetz/gruvbox'
  Plug 'sainnhe/sonokai'

  call plug#end()
endif

"}}}
" -------------------------------------------------

" -------------------------------------------------
"{{{ settings

"let g:UltiSnipsExpandTrigger="<CR>
"let g:UltiSnipsExpandTrigger="<c-b>"

" rendering
set encoding=utf-8
set nocompatible
set ttyfast
set synmaxcol=256
set t_Co=256
set termguicolors

" mode switch delays
set ttimeout
set ttimeoutlen=30
set timeoutlen=3000

" editor
filetype indent on
set number relativenumber " relative numbers
set cursorline " highlight current line
set showmatch " hl matching [{(s
"hi MatchParen cterm=bold ctermbg=darkgray ctermfg=white

" whitespace
set wrap
set scrolloff=10
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" invisibles
exec "set listchars=trail:␣"
set list

" search
set incsearch " search as characters are entered
set hlsearch " highlight matches
set ignorecase " case-insensitive search
set smartcase " case-sensitive if search contains uppercase
set showmatch
nnoremap // :noh<return>

" clipboard woes, remember xsel
set clipboard+=unnamedplus

" disable new line comment
autocmd FileType * setlocal formatoptions-=cro

" code folding
filetype plugin indent on
set foldenable
set foldmethod=marker
syntax enable

function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart('          ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount) - 1
  return line . ' ' . repeat(" ", fillcharcount) . ' ' . foldedlinecount . '  '
endfunction

set foldtext=MyFoldText()

" hide CursorLine in insert mode
autocmd InsertEnter * set nocul
autocmd InsertLeave * set cul

"}}}
" -------------------------------------------------

" -------------------------------------------------
"{{{ vim magic

" pass cword to a bash script an echo the output
function! SaveCurrentWord()
  let cword = expand("<cword>")
  let cword_command = 'output-test ' . cword
  let cwordout = system(cword_command)
  echom cwordout
  " maybe grep the thesaurus with inverted keyboard too
  " ideally i'd want to print a list with numbers, and if a type m1 or something it replaces cword with that numbered word
endfunction

" writing mode
let g:writing_mode_enabled = 0
function! WritingMode()
  if g:writing_mode_enabled
    set spell!
    DittoOff
    " autocmd! CWord
    let g:writing_mode_enabled = 0
  else
    call lexical#init({
      \ 'spell': 1,
      \ 'spellang': ['en', 'geographic'],
      \ 'dictionary': ['~/Downloads/cut.txt',
      \                '/usr/share/dict/words',
      \               ],
      \ 'thesaurus': ['~/.vim/thesaurus/mthesaur.txt',
      \              ],
      \ 'spellfile': ['~/.vim/spellcheck/geograpgic.utf-8.add',
      \              ],
      \ })
    DittoOn
    " augroup CWord
    "   autocmd CursorMoved * call SaveCurrentWord()
    " augroup END
    let g:writing_mode_enabled = 1
  endif
endfunction
command! WritingMode call WritingMode()

" auto-update current buffer if it's been changed from somewhere else
set autoread
augroup autoRead
    autocmd!
    autocmd CursorHold * silent! checktime
augroup END

" recompile suckless programs automagically
autocmd BufWritePost config.h,config.def.h !sudo make install

" run xrdb whenever Xdefaults or Xresources are updated
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

"}}}
" -------------------------------------------------

" -------------------------------------------------
"{{{ keymaps

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

" easier split movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" vi-line movement
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" cyrillic bindings
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"}}}
" -------------------------------------------------

" -------------------------------------------------
" filetype specific
" -------------------------------------------------

" python
au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

" -------------------------------------------------
"{{{ plug specific

" thesaurus_query
nnoremap zw :ThesaurusQueryReplaceCurrentWord<CR>

" vim-ditto
hi clear SpellBad
hi SpellBad ctermfg=red guifg=#fb4934
execute 'hi SpellCap guifg=#fb4934'
exec 'hi SpellDitto guifg=#fabd2f ctermfg=red'
let g:ditto_hlgroups = ['SpellDitto', ]

" fzf-vim
nnoremap <C-F> :Files<cr>
vnoremap <C-F> <esc>:Files<cr>
inoremap <C-F> <esc>:Files<cr>

" vimtex
let g:tex_flavor  = 'latex'
let g:tex_conceal = ''
"let g:vimtex_fold_manual = 1
let g:vimtex_latexmk_continuous = 1
"let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_latexlog = {'default' : 0}

" indent line
let g:indentLine_char = '│'

" gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'
let g:gruvbox_italic = '1'
let g:gruvbox_bold = '0'

" onedark
let g:onedark_color_overrides = {
\ "black": {'gui': '#282c34', 'cterm': '0', 'cterm16': '0' }
\}

try
  " theme : DO NOT REMOVE THIS TAG
colorscheme gruvbox
  catch
  try
    colorscheme termcolors
    catch
  endtry
endtry

" remove fold bg
" FIXME set this to comment bg color
"highlight Folded guibg=NONE ctermbg=NONE
"highlight CursorLine guifg=NONE guibg=NONE cterm=nocombine

"set foldcolumn=1
"highlight FoldColumn guifg=grey guibg=bg
"hi! link Folded User5

"}}}
" -------------------------------------------------

" -------------------------------------------------
" sources (keep at the end)
" -------------------------------------------------
source ~/blueberry/vim/statusline.vim

" vim-ditto
"au FileType markdown,text,tex DittoOn
hi clear SpellBad
hi SpellBad ctermfg=red guifg=#fb4934
hi clear SpellCap
hi SpellCap guifg=#fabd2f
hi clear SpellRare
hi SpellRare guifg=#d3869b
hi SpellDitto guifg=#83a598
let g:ditto_hlgroups = ['SpellDitto']
