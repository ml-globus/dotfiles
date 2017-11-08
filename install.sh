#!/usr/bin/env bash

#Config

git submodule init
git submodule update

DOTFILES="
	vim 
	vimrc 
    tmux.conf
	bashrc 
	bash_logout 
	bash_profile
	inputrc
"


# Do the install
cd $(dirname $0)

for file in $DOTFILES; do
	echo "Linking $file"
	ln -sfT $PWD/$file ~/.$file
done

mkdir ~/.bash_logs # Needed by .bashrc
