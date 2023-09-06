#!/bin/bash
set -e
set -x

sudo apt-get -y update
sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive  apt-get install --no-install-recommends -y \
	htop \
	ipe \
	iproute2 \
	lcov \
	menu \
	mesa-utils \
	openbox \
	python3-jinja2 \
	python3-numpy \
	python3-vcstool \
	python3-xdg \
	python3-xmltodict \
	qt5dxcb-plugin \
	screen \
	terminator \
	vim

sudo pip install pykwalify