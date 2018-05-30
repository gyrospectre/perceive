#!/bin/sh

# Install Docker CE Ubuntu AMI
# Credit to Gary Stafford
# https://raw.githubusercontent.com/garystafford/ami-docker-ce-packer/master/packer/bootstrap_docker_ce.sh

# set -e

sudo apt-get remove docker docker-engine

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    python \
    python-setuptools \
    python-pip

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y docker-ce

sudo groupadd docker
sudo usermod -aG docker ubuntu

sudo systemctl enable docker

docker --version