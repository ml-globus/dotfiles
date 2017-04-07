#!/usr/bin/env bash

PACKAGES="
	vim 
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
"

apt-get update

for package in $PACKAGES; do
	apt-get install $package -y
done