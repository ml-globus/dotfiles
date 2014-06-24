#!/usr/bin/env bash

#Config

git submodule init
git submodule update
cd vim/bundle/pyflakes-vim
git submodule init
git submodule update

DOTFILES="
	vim 
	vimrc 
	bashrc 
	bash_logout 
	bash_profile
	inputrc
	gconf/apps/gnome-terminal/profiles/Default/%gconf.xml
	gconf/apps/gnome-terminal/keybindings/%gconf.xml
"


# Do the install
cd $(dirname $0)

git submodule init
git submodule update

for file in $DOTFILES; do
	echo "Linking $file"
	ln -sfT $PWD/$file ~/.$file
done
