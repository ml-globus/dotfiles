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
	gconf/apps/gnome-terminal/profiles/Default/%gconf.xml
	gconf/apps/gnome-terminal/keybindings/%gconf.xml
"


# Do the install
cd $(dirname $0)

for file in $DOTFILES; do
	echo "Linking $file"
	ln -sfT $PWD/$file ~/.$file
done

mkdir ~/.bash_logs # Needed by .bashrc

wget -O vim/plugin/pythonhelper.vim http://www.vim.org/scripts/download_script.php?src_id=12010
