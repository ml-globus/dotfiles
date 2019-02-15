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
	psqlrc
	inputrc
"


# Do the install
cd $(dirname $0)

for file in $DOTFILES; do
	echo "Linking $file"
	ln -sfT $PWD/$file ~/.$file
done

mkdir ~/.vim/keymap
ln -sfT $PWD/keymap/swe-us_utf-8.vim ~/.vim/keymap/swe-us_utf-8.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

vim +PluginInstall +qall # Run Vundle installs

# TODO: Get Vim8 or NeoVim by default
# TODO: Run :PluginInstall automatically

mkdir ~/.bash_logs # Needed by .bashrc
source ~/.bashrc
