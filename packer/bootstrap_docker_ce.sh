#!/bin/sh

# Install Docker CE Ubuntu AMI
# Credit to Gary Stafford
# https://raw.githubusercontent.com/garystafford/ami-docker-ce-packer/master/packer/bootstrap_docker_ce.sh

# set -e
sudo apt-get update
sudo apt-get remove docker docker-engine

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y docker-ce
sudo apt-get install -y python python-setuptools python-pip
sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo systemctl enable docker

pip install setuptools six docker-py docker-compose==1.9.0

docker --version