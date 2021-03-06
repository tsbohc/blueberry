(module rc.settings
  {require {se zest.set}
   require-macros [zest.macros]})

; rendering ;
(se- encoding "utf-8")              ; self-explanatory
(se- synmaxcol 256)                 ; max colums to use highlighting on
(se- termguicolors)                 ; true color support

; ui ;
(se- number)                        ; show ruler
(se- relativenumber)                ; relative ruler
(se- cursorline)                    ; highlight current line
(se- showmatch)                     ; blink matching brace when a new one is inserted
(se- matchtime 2)                   ; blink quicker
(se- shortmess                      ; disable messages
     (.. "I"   ; intro
         "c")) ; completion

; behaviour ;
(se- scrolloff 10)                  ; cursor padding in window
(se- nowrap)                        ; do not wrap long lines
(se- virtualedit "block")           ; do not restrict v-block to characters
(se- undofile)                      ; persistent undo/redo
(se- clipboard "unnamedplus")       ; don't forget xsel!
(se- mouse "a")                     ; blasphemy!

; status lines ;
(se- noshowmode)                    ; do not show -- INSERT -- etc on statusline
(se- laststatus 2)                  ; always show statusline

; folding ;
(se- foldenable)
(se- foldmethod "marker")
;(se- foldtext "v:lua.folding()"

; search ;
(se- incsearch)                     ; search as characters are typed
(se- inccommand "nosplit")          ; show substitute effects as characters are typed
(se- hlsearch)                      ; highlight matches
(se- ignorecase)                    ; case-insensitive search
(se- smartcase)                     ; case-sensitive if search contains uppercase

; spacing ;
(se- tabstop 2)
(se- shiftwidth 2)
(se- softtabstop 2)
(se- expandtab)
;(se- :noshiftround)                  ; round indent to multiples of shiftwidth

; invisibles ;
(se- listchars "trail:␣")
(se- list)
;(se- :fillchars "eob:~")             ; do not set those to fileseparator etc, trust me

(def-cmd Testt [a]
  (print (.. "hi, " a)))

; unsorted ;
;(se- compatible false)              ; allow vim -u vimc
