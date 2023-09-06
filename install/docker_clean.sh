#!/bin/bash
set -e
set -x

sudo apt-get clean -y
sudo apt-get autoremove --purge -y
sudo rm -rf /var/lib/apt/lists/*
sudo rm -rf /tmp/*