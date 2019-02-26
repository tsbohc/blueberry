#!/usr/bin/env python3
from __future__ import print_function
#
import json
import os
import shutil
import subprocess
import datetime
import sys
import argparse

try: input = raw_input
except NameError: pass

subprocess.run('clear')

dry = False

colors = {
    'red': '\x1b[31m',
    'green': '\x1b[32m',
    'blue': '\x1b[34m',
    'yellow': '\x1b[33m',
    'gray': '\x1b[90m',
    'escape': '\x1b[0m'
}

dots = colors['blue'] + '...' + colors['escape']
colon = colors['blue'] + ': ' + colors['escape']

def echo_title(string):
    print('--- ' + string + dots)

def echo(string, end=True, color=None):
    if color:
        print(colors[color] + string + colors['escape'], end='')
    else:
        print(string, end='')
    if end:
        print('')

def log(icon, color, string, end=True):
    if end == True:
        print('[' + colors[color] + icon + colors['escape'] + '] ' + string) 
    else:
        print('[' + colors[color] + icon + colors['escape'] + '] ' + string, end='') 

def ask_user(prompt):
    valid = { "yes":True, 'y':True, "no":False, 'n':False }
    while True:
        log('?', 'yellow', prompt + " [y/n] | ", False)
        choice = input().lower()
        if choice in valid:
            return valid[choice]
        else:
            log('#', 'red', 'please enter a valid choice')

def create_directory(path):
    exp = os.path.expanduser(path)
    if not os.path.isdir(exp):
        if not dry:
            log('+', 'green', path)
            os.makedirs(exp)
        else:
            log('+', 'yellow', path)
    else:
        if not dry:
            log('#', 'red', path)

def check_symlink(path):
    if os.path.islink(path):
        target_path = os.readlink(path)
        if not os.path.isabs(target_path):
            target_path = os.path.join(os.path.dirname(path), target_path)
        if not os.path.exists(target_path):
            return True

def create_symlink(src, dst):
    dst = os.path.expanduser(dst)
    src = os.path.abspath(src)
    backup_dir = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'backup')
    
    # create necessary dirs
    if not os.path.isdir(os.path.dirname(dst)):
        if not dry:
            log('+', 'green', os.path.dirname(dst))
            os.makedirs(os.path.dirname(dst))
        else:
            log('+', 'yellow', os.path.dirname(dst))
    
    # check for broken symlinks
    if check_symlink(dst):
        if not dry:
            log('×', 'yellow', '~/' + os.path.relpath(dst, os.path.expanduser('~')) + colon + 'broken symlink, removing' + dots)
            os.remove(dst)
        else:
            log('×', 'yellow', '~/' + os.path.relpath(dst, os.path.expanduser('~')) + colon + 'broken symlink, remove')
    
    # stop if a non-symlink with the same name is found
    if os.path.isfile(dst) and not os.path.islink(dst):
        log('#', 'red', '~/' + os.path.relpath(dst, os.path.expanduser('~')))
        if not dry:
            if ask_user("non-symlink found, back it up?"):
                if not os.path.isdir(backup_dir): os.mkdir(backup_dir)
                log('+', 'green', os.path.relpath(os.path.join(backup_dir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S') + '_' + os.path.basename(dst))))
                os.rename(dst, os.path.join(backup_dir, datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S') + '_' + os.path.basename(dst)))
            else:
                os.remove(dst)
        else:
            log('?', 'yellow', 'ask what to do with the file')

    # check if source file exists
    if os.path.exists(src):
        if not dry:
            log('↣', 'blue', os.path.relpath(src) + colon + '~/' + os.path.relpath(dst, os.path.expanduser('~')))
            if os.path.exists(dst):
                os.remove(dst)
            os.symlink(src, dst)
        else:
            log('↣', 'yellow', os.path.relpath(src) + colon + '~/' + os.path.relpath(dst, os.path.expanduser('~')))
    else:
        log('!', 'red', os.path.relpath(src) + colon + 'does not exist, skipping' + dots)


def copy_path(src, dst):
    dst = os.path.expanduser(dst)
    src = os.path.abspath(src)
    if os.path.exists(dst):
        if ask_user("{0} exists, delete it?".format(dst)):
            if os.path.isfile(dst) or os.path.islink(dst):
                os.remove(dst)
            else:
                shutil.rmtree(dst)
        else:
            return
    print("Copying {0} -> {1}".format(src, dst))
    if os.path.isfile(src):
        shutil.copy(src, dst)
    else:
        shutil.copytree(src, dst)


def run_command(command):
    if not dry:
        log('>', 'green', command)
        subprocess.run(command, shell=True)
    else:
        log('>', 'yellow', command)

#parser = argparse.ArgumentParser()
#parser.add_argument("config", help="the JSON file you want to use")
#parser.add_argument("-r", "--replace", action="store_true",
#                    help="replace files/folders if they already exist")
#args = parser.parse_args()
#js = json.load(open(args.config))
#os.chdir(os.path.expanduser(os.path.abspath(os.path.dirname(args.config))))

try:
    js = json.load(open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'config.json')))
except FileNotFoundError:
    log('!', 'red', 'blueberry could not find config.json, exiting' + dots)
    sys.exit(1)

def install(dry_run=False):
    global dry
    dry = dry_run
    if 'mkdir' in js:
        echo_title('making directories')
        [create_directory(path) for path in js['mkdir']]
    if 'link' in js:
        echo_title('linking dots')
        #[create_symlink(src, dst, args.replace) for src, dst in js['link'].items()]
        [create_symlink(src, dst) for src, dst in js['link'].items()]
    if 'copy' in js:
        echo_title('copying stuff')
        [copy_path(src, dst) for src in js['copy'].items()]
    if 'install' in js:
        if not os.path.exists('/usr/bin/yay'):
            echo_title('installing yay')
            if not dry:
                run_command('git clone https://aur.archlinux.org/yay.git')
                os.chdir('yay')
                run_command('makepkg -si --noconfirm')
                os.chdir('..')
                log('>', 'green', 'cleaning up' + dots)
                shutil.rmtree('yay')
            else:
                log('>', 'yellow', 'git clone https://aur.archlinux.org/yay.git')
                log('>', 'yellow', 'cd yay')
                log('>', 'yellow', 'makepkg -si --noconfirm')
                log('>', 'yellow', 'cd ..')
                log('>', 'yellow', 'rm -r yay')
        echo_title('installing packages')
        for pkg in js['install']:
            if not dry:
                log('>', 'green', pkg)
                subprocess.run('yay -S --needed --noconfirm ' + pkg + ' --color=always | grep --color=never "error\|warning"', shell=True)
            else:
                log('>', 'yellow', pkg)
    if 'run' in js:
        echo_title('running commands')
        [run_command(command) for command in js['run']]
    if not dry:
        echo_title('finishing up') 
    else:
        echo_title('completing dry run')

def dry():
    install(True)

def reap():
    if 'link' in js:
        echo_title('reaping configs')
        for src, dst in js['link'].items():
            exp_dst = os.path.expanduser(dst)
            exp_src = os.path.abspath(src)
            if not os.path.islink(exp_dst):
                if not os.path.exists(exp_src):
                    log('+', 'green', dst + colon + src)
                    os.rename(exp_dst, exp_src)
                else:
                    log('#', 'red', dst + colon + 'file is already on the local branch')

def delete():
    if 'link' in js:
        echo_title('removing symlinks')
        for src, dst in js['link'].items():
            exp_dst = os.path.expanduser(dst)
            if os.path.islink(exp_dst):
                echo(dst)

def update():
    global dry
    dry = False
    echo_title('checking for updates')
    run_command('git fetch')
    log('>', 'green', 'git status')
    
    if "behind" in str(subprocess.check_output(['git', 'status'])):
        if ask_user('the local branch is behind, pull?'):
            run_command('git pull')

    elif "ahead" or "up to date" in str(subprocess.check_output(['git', 'status'])):
        if subprocess.run('git diff-index --quiet HEAD --', shell=True):
            if ask_user('the local branch is ahead, push?'):
                run_command('git add .')
                log('?', 'yellow', 'enter a commit message | ', False)
                while True:
                    message = input().lower()
                    run_command('git commit -m "' + message + '" --quiet')
                    break
                run_command('git push --quiet')
        else:
            log('i', 'yellow', 'there is nothing to do') 
    
    echo_title('finishing up') 


def main():
    echo("       _                              ", True, "blue")
    echo("  /   //         /                    ", True, "blue")
    echo(" /__ //  . . _  /__ _  __  __  __  ,  ", True, "blue")
    echo("/_) </_ (_/_</_/_) </_/ (_/ (_/ (_/_ ❤", True, "blue")
    echo("                                 /    ", True, "blue")
    echo("what would you like to do?", False)
    echo("      '   ", True, "blue")

    echo('i', False, 'blue')
    echo('nstall, ', False)
    echo('r', False, 'blue')
    echo('eap, ', False)
    echo('d', False, 'blue')
    echo('ry, ', False)
    if subprocess.run('git diff-index --quiet HEAD --', shell=True):
        echo('!', False, 'blue')
    echo('u', False, 'blue')
    echo('pdate' + dots + ' ', False)

    global dry

    menu = {
        'i': install,
        'r': reap,
        'd': dry,
        'u': update
    }

    while True:
        choice = input().lower()
        if choice in menu:
            result = menu.get(choice)
            result()
            break
        else:
            log('i', 'yellow', "please enter a valid choice | ", False)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print('')
        sys.exit(1)
