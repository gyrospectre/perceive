#!/bin/bash

# Cleanup AMI after installs
# Credit to Gary Stafford
# https://raw.githubusercontent.com/garystafford/ami-docker-ce-packer/master/packer/bootstrap_docker_ce.sh

set -e

echo 'Cleaning up after bootstrapping...'
sudo apt-get -y autoremove
sudo apt-get -y clean
sudo rm -rf /tmp/*
cat /dev/null > ~/.bash_history
history -c
exit