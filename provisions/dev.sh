#!/bin/sh

apt-get update
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg-agent \
software-properties-common

sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install -y docker-ce

sudo usermod -aG docker vagrant
sudo docker run hello-world

echo "Insert untrusted docker registry to docker list"
sudo cp /vagrant_config/registry.docker.daemon.json /etc/docker/daemon.json
sudo service docker restart

sudo cat /vagrant_config/drone_cn | sudo tee -a /etc/hosts

echo "Install pip and docker for ansible deployment"
sudo apt-get install -y python-pip python-dev build-essential
sudo pip install docker
