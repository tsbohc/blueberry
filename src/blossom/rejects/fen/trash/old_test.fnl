







; {{{
;(print (inspect (varset :kohi)))

; old one for reference
;(fn load-varset [name]
;  (when (nil? (. _L.varsets name))
;    (tset _L.varsets name {})
;    (var varset (. _L.varsets name))
;    (with-open
;      [file (io.open (.. "varsets/" name) "r")]
;      (each [line (file:lines)]
;        (when
;          (not (or (line:match "%s*!") (= line "")))
;          (let [(key val) (line:match "(%w+):%s*(%w+)")]
;            (tset varset key val)))))))
; }}}














































;(fn wrap [b f]
;  (f b))
;
;(wrap
;  "bbb"
;  (fn [a]
;    (print a)))
;
;(wrap
;  "ccc"
;  #(print $1))
























;(global inspect (require :inspect))
;(global Varset (require :varset))
;;
;;
;;
;;
;;(var v (Varset:load "kohi"))
;;(var v (Varset:load "kohi"))
;;(var v (Varset:load "kohi"))
;;
;;(print (inspect varsets))
;;
;;;(varsets.kohi:bark)
;;
;;(print varsets.kohi.arstrs)
;
;
;
;(global varsets {})
;
;(fn get-node [node-path]
;  (var v _G)
;  (each [w (node-path:gmatch "[%w_]+")]
;    (if (= v nil) nil (set v (. v w))))
;  v)
;
;(global varset {})
;
;(fn varset.new [name]
;  (when (nil? (. varsets name))
;    (tset varsets name {})
;    (with-open [file (io.open (.. "varsets/" name) "r")]
;      (each [line (file:lines)]
;        (varset.parse name line)))))
;
;(fn varset.parse [name line]
;  (when (not (or (line:match "%s*!") (= line "")))
;    (let [(key val) (line:match "(%w+):%s*(%w+)")]
;      (varset.add name key val))))
;
;(fn varset.add [name key val]
;  (tset (. varsets name) key val))
;
;(varset.new :kohi)
;(varset.new :whoah)
;(print (inspect varsets))




;(each [_ path (ipairs paths)]
;  (let [petal (Petal path)]
;    (petal:set-target) ; need to delete initial string from file
;    (each [_ match in (ipairs (petal:patterns))]
;      (let [pattern (Pattern match)]
;        (pattern:compile)
;        (petal:add-pattern pattern)))))




;(fn main [...]
;  (let [paths [...]]
;    (each [_ path (ipairs paths)]
;      (Petal:new path))))






;(var colo "kohi")
;(var font "fira")
;(var font-size 12)
;
;(fn alacritty [varsets links]
;  (print (inspect varsets))
;  (print (inspect links)))
;
;(fn req [a]
;  a)
;
;(alacritty
;  [colo font { : font-size }]
;  [:alacritty.yml "~/.config/alacritty/alacritty.yml"])
;
;(alacritty
;  (l- "alacritty.yml" (.. conf "alacritty/alacritty.yml")))
;  (<= colo "literal" { : font-size })
;
;(doto "alacritty"
;  (: :link "alacritty.yml" (.. conf "alacritty/alacritty.yml")))

;(blossom #(let [font_size 12]
;  (alacritty [colo font  {: font_size }]
;             [:alacritty.yml :~/.config/alacritty/alacritty.yml])
;
;  ))

;(require-macros :macros)
;(global inspect (require :inspect))
;
;
;(var cherry (require :cherry))
;(cherry.begin
;  #(print "wooo"))
;
;; cherry
;; --------------
;
;(var cherry {})
;
;(fn link [link-id varsets]
;  (print link-id)
;  (print (inspect varsets)))
;
;(var LINKS
;  {:alacritty ["alacritty.yml" "^/alacritty.alacritty.yml"]})
;
;; blossom
;; --------------
;
;(fn cherry.blossom []
;  (global colo "kohi")
;
;  (lyn alacritty [colo]
;       (sh [yay -S alacritty]
;           [echo "installed alacritty"]))
;
;  (lyn bspwm)
;  (lyn sxhkd)
;
;
;  )
;
;;(cherry.blossom)


























;(require-macros :macros)
;(var z (require :lib))
;(global yaml (require :lyaml))
;
;(fn load-config []
;  (with-open [f (io.open "test.yml" :rb)]
;             (yaml.load (f:read "*all"))))
;
;(var config (load-config))
;
;(print (inspect config))

;(var VARSETS
;  [:fg {:v "E4D6C8" :s "kohi"}])
;
;(fn get-var [varname]
;  (. VARSETS :test))
;
;(fn def-set [name xs]
;  (each ))
;
;(def-set :kohi
;  {:fg "E4D6C8" :bg "2b2b2c"})



;(fn index-as-method [callback]
;  "translates callback(parameter) to table.parameter()"
;  (setmetatable
;    {} {:__index
;        (fn [self index]
;          (tset self index (fn [...] (callback index ...)))
;          (rawget self index))}))
;
;(fn shell [command ...]
;  (with-open [handle (io.popen (.. command " " (z.flatten [...] " ")))]
;             (let [result (handle:read "*a")]
;               result)))
;
;(var sh (index-as-method shell))
;
;; ideally, i want this:
;;(sh.yay -S wooo)
;; and piping with (->>) macro
;; but, quoting stuff will be awful due to "" being lost
;
;

















































