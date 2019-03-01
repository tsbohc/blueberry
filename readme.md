```
       _                              
  /   //         /                    
 /__ //  . . _  /__ _  __  __  __  ,  
/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤
                                 /    
                                '
```

- symlinks everything, creating dirs as needed
- asks to back up non-symlinks in case of conflicts 
- has a dry install option
- installs yay from git, uses it to get packages
- sets up nvim by downloading plug and running pluginstall
- can reap dots, cloning config files into the repo
- shows when local branch has diffs, is able to pull/push changes 

## about
- bashrc: 
    - promt that is git aware
    - tty colors are read from .Xresources
- nvim:
    - plug:
        - valloric/youcompleteme
        - itchyny/lightline
        - terryma/vim-multiple-cursors
    - colors:
        - nanotech/jellybeans.vim
        - matching theme for lightline
- st:
    - tamzenforpowerline
    - scrollback
    - boxdraw
- wm:
    - i3-gaps
        - olemartinorg/i3-alternating-layout
    - compton
    - polybar
    - rofi

## todo
- add the ability to install only a single dotfile
- retroarch configs
- redo folder creation to allow reap to do that
- add firefox theme
- add a cool gif
- look into bropages etc

## config.json
```js
{
    "mkdir": [
        "~/downloads",
        "~/pictures",
        "~/projects"
    ],

    "link": {
        "bashrc": "~/.bashrc",
        "aliases": "~/.aliases",
        "bash_profile": "~/.bash_profile",
        "xinitrc": "~/.xinitrc",
        "Xresources": "~/.Xresources",
        
        "vimrc": "~/.vimrc",
        "vim/colors/jellybeans.vim": "~/.vim/colors/jellybeans.vim",
        "vim/jellybeans_lightline.vim": "~/.vim/bundle/lightline.vim/autoload/lightline/colorscheme/jellybeans_lightline.vim",
        "vim/nvim_init.vim": "~/.config/nvim/init.vim",

        "neofetch/neofetch.conf": "~/.config/neofetch/config.conf",
        "neofetch/punpun": "~/.config/neofetch/punpun",

        "i3": "~/.config/i3/config",
        "compton": "~/.config/compton.conf",
        "polybar": "~/.config/polybar/config"
    },

    "install": [
        "neovim",
        "python2-pip",
        "python-pip",
        "xsel"
    ],

    "run": [
        "sudo pip2 install pyvim",
        "sudo pip install pyvim"
    ]
}
```
