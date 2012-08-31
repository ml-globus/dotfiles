#!/usr/bin/env bash

#Config

DOTFILES="
	vim 
	vimrc 
	bashrc 
	bash_logout 
	bash_profile
	inputrc
"


# Do the install
cd $(dirname $0)

git submodule init
git submodule update

for file in $DOTFILES; do
	echo "Linking $file"
	ln -sfT $PWD/$file ~/.$file
done
