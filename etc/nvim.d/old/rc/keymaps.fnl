(module rc.keymaps
  {require {z zest.lib
            k zest.keys}
   require-macros [zest.macros]})

; TODO: redo with macros
; init helpers
(keys-begin)

; first off
(k.localleader " ")
(k.leader " ")

; ------------------------------------
; -- land of opinionated navigation --
; ------------  --/-<@  --------------

; smart v-line movement
(k.nvo [expr] :e #(if (> vim.v.count 0) :k :gk))
(k.nvo [expr] :n #(if (> vim.v.count 0) :j :gj))

; vertical
(k.n :N :<c-d>)
(k.n :E :<c-u>)
(k.v :N :<Nop>)
(k.v :E :<Nop>)

; horizontal
(k.nv :H :0)
(k.nv :I :$)
(k.nv :<ScrollWheelUp> :<c-y>)
(k.nv :<ScrollWheelDown> :<c-e>)

; split-wise
(k.n :<c-h> :<c-w>h)
(k.n :<c-n> :<c-w>j)
(k.n :<c-e> :<c-w>k)
(k.n :<c-i> :<c-w>l)

; consistency
(k.n :Y :y$)

; fixes
(k.n :<c-j> :J)

; ------------------------------------
; --      search and replace        --
; ------------  --/-<@  --------------

; general
(k.n [silent] :// ::noh<cr>)
(k.n [silent] :* :*N) ; check if there's an entry above?

; smart replace
(k.n :<leader>r ::%s///g<left><left>)  ; replace searched text
(k.x :<leader>r ::s///g<left><left>)   ; same but in current v-selection

; search for selected text
(k.x :* #(do (z.norm "gvy") (z.exec (.. "/" (z.eval "@\""))) (z.norm "<c-o>")))

; undo-redo
(k.n :U :<c-r>)

; stay visual when indenting
(k.x :< :<gv)
(k.x :> :>gv)

;(k.n :<leader>h
;     #(let [cword (vim.fn.expand "<cword>")]
;        ))

; colemak
;(k.nvo :n :j)
;(k.nvo :N :J)

;(k.nvo :e :k)
;(k.nvo :E :K)

(k.nvo :i :l)
;(k.nvo :I :L)

(k.nvo :l :i)
(k.nvo :L :I)

(k.nvo :k :n)
(k.nvo :K :N)

(k.nvo :j :f)
(k.nvo :J :F)

(k.nvo :f :e)
(k.nvo :F :E)

