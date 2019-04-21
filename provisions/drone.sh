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
sudo cp /vagrant_shared/registry.docker.daemon.json /etc/docker/daemon.json
sudo service docker restart

sudo mkdir -p /keys
sudo cp /vagrant_config/drone.nginx.crt /keys/drone.nginx.crt
sudo cp /vagrant_config/drone.nginx.key /keys/drone.nginx.key

echo "Install and configure nginx"
sudo apt-get -y install nginx
sudo rm /etc/nginx/sites-available/default
sudo cp /vagrant_config/drone.nginx.conf /etc/nginx/sites-available/default
sudo cp /vagrant_config/registry.nginx.pswd /etc/nginx/conf.d/registry.nginx.pswd
sudo service nginx configtest
sudo service nginx reload

echo "Pulling and starting drone"
docker pull drone/drone:1
sh /vagrant_config/drone.sh

echo "Running docker registry"
sudo mkdir /auth
sudo cp /vagrant_config/registry_auth.pswd /auth/htpasswd
sudo chmod 777 -R /auth
sh /vagrant_config/registry.sh

echo "Adding registry domain to /etc/hosts"
sudo cat /vagrant_shared/drone_cn | sudo tee -a /etc/hosts

# need manual call this after vagrant up
echo "Configure ssh for deploy"
mkdir -p ~/.ssh
sudo cp /ansible/ansible_ssh_key ~/.ssh/ansible
sudo cp /ansible/ansible_ssh_key.pub ~/.ssh/ansible.pub
sudo cp /ansible/ansible_ssh_config ~/.ssh/config
