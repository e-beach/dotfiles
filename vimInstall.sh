#!/usr/bin/bash

# this script installs vundle on vim.

mkdir "$HOME/.vim"
cd "$HOME/.vim"
mkdir swaps
mkdir backups
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

