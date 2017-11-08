#!/usr/bin/env bash

PACKAGES="
	vim 
	vim-gtk
	tree
	htop
	screen
	python-dev
	vagrant
	synaptic
	pidgin
	ctags
	virtualenv
	python-pip
	jq
"

apt-get update

for package in $PACKAGES; do
	apt-get install $package -y
done
