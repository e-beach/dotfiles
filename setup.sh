#!/usr/bin/bash

#
# Overwrite dotfiles in home directory with symlinks to the dofiles in this git repo.
#

# Exit immediatly on any error, as we could delete important stuff.
set -e

# `readlink -f` does not work on OSX.
# see http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
DOTFILES="/Users/elliott/me/projects/dotfiles"

echo $DOTFILES
cd $DOTFILES

function doIt() {

    for f in \
        .aliases .bash_prompt .bashrc .curlrc .editorconfig .exports .extras .functions .gitconfig .gitignore .hushlogin .screenrc .vimrc .wgetrc
    do
        dest="$HOME/$f"
        src="$DOTFILES/$f"
        ln -f -s "$src" "$dest"
    done

    # install vim plugins and vimrc
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
