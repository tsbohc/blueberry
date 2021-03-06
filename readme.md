```
                                                   /)
                                     _   _   __  _(/  _  __
                                  . (_/_(_(_/ (_(_(__(/_/ (_
                                   .-/
                                  (_/
```
## nvim

#### init.lua
Written in [fennel](https://github.com/bakpakin/Fennel/), a lisp that compiles to lua, via [zest](https://github.com/tsbohc/zest.nvim).

```clojure
; options
(so- cursorline)
(so- completeopt:append ["menuone" "noselect"])
(so- listchars {:trail "␣"})

; keybinds
(ki.fn- :e [nv :expr] (if (> vim.v.count 0) "k" "gk"))
(ki.fn- :n [nv :expr] (if (> vim.v.count 0) "j" "gj"))

(ki.no- [nv]
  {:<ScrollWheelUp>   "<c-y>"
   :<ScrollWheelDown> "<c-e>"})

; autocmds
(au.gr- :restore-position
  (au.fn- "*" [BufReadPost]
    (when (and (> (vim.fn.line "'\"") 1)
               (<= (vim.fn.line "'\"") (vim.fn.line "$")))
      (vim.cmd "normal! g'\""))))
```

## addendum
- I'm not a programmer by trade, but I like writing code. As such, it is very [opinionated](https://i.redd.it/se5rfanqhqx11.jpg).
- Feel free to look around, fork, and praise or yell at me in an issue!
- Giving credit is appreciated.

Thanks!
