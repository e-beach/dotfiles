#!/usr/bin/bash

# This script is intended to be run after setup.sh, as it copies all the files in our home directory to here. And overwrites all of the files here.

# sudo apt-get install realpath

set -e

DOTFILES="$( dirname "$( readlink -f "$0" )" )"
echo $DOTFILES
cd $DOTFILES

function doIt() {

    for f in \
        .aliases .bash_prompt .bashrc .curlrc .editorconfig .exports .extras .functions .gitconfig .gitignore .hushlogin .screenrc .vimrc .wgetrc
    do
        dest="$HOME/$f"
        src="$DOTFILES/$f"
        echo $src
        ln -f -s "$src" "$dest"
    done

    # install vundle
    bash vimInstall.sh
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
