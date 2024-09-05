#!/bin/bash
set -e
set -x

GAZEBO_VERSION="harmonic"

sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get -y update
sudo apt-get -y upgrade
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
	gz-${GAZEBO_VERSION}
sudo apt install -y libignition-gazebo6-dev
