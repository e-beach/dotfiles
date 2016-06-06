#!/usr/bin/bash

# Copy all files in the list from the home directory to here ; overwrites all the files here
# could add git add to make more effective/robust

set -e

dotfilesg="$(realpath "$(dirname "$0")")"

for f in \
    .vim .aliases .bash_prompt .bashrc .curlrc .editorconfig .exports .extras .functions .gitconfig .gitignore .hushlogin .screenrc .vimrc .wgetrc
do
    dest="$HOME/$f"
    src="$dotfilesg/$f"
    echo $src
    if [[ ! -h $dest ]] ; then
        cp -rf "$dest" .
    fi
    ln -f -s "$src" "$dest"
done
