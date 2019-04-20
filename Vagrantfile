# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "gogs" do |gogs|
    gogs.vm.box = "ubuntu/trusty64"
    gogs.vm.synced_folder "./config/gogs", "/vagrant_config"
    gogs.vm.network "private_network", ip: "192.168.50.4"
    gogs.vm.hostname = "gogs"

    gogs.vm.provision "shell", inline: <<-SHELL
      apt-get update
      sudo apt install -y git
      sudo apt-get -y install supervisor
      wget https://dl.gogs.io/0.11.86/gogs_0.11.86_linux_amd64.tar.gz
      tar -xvzf gogs_0.11.86_linux_amd64.tar.gz
      rm gogs_0.11.86_linux_amd64.tar.gz
      sudo mkdir -p /var/log/gogs

      # need manual call this after vagrant up
      sudo cat /vagrant_config/gogs.skip_tls.conf >> /home/vagrant/gogs/custom/conf/app.ini

      cp /vagrant_config/gogs.supervisor.conf /etc/supervisor/conf.d/gogs.supervisor.conf

      echo "Reload supervisor and get gogs service status"
      sudo service supervisor restart
      ps -ef | grep gogs

      echo "Install and configure nginx"
      sudo apt-get -y install nginx
      cp /vagrant_config/gogs.nginx.conf /etc/nginx/sites-available/gogs
      sudo ln -s /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs
      sudo service nginx configtest
      sudo service nginx reload
    SHELL
  end

  config.vm.define "drone" do |drone|
    # drone.vm.box = "ubuntu/trusty64"
    drone.vm.box = "bento/ubuntu-18.04"
    drone.vm.synced_folder "./config/drone", "/vagrant_config"
    drone.vm.synced_folder "./config/ansible", "/ansible"
    drone.vm.synced_folder "./config/", "/vagrant_shared"
    drone.vm.network "private_network", ip: "192.168.50.5"
    drone.vm.hostname = "deploy"

    drone.vm.provision "shell", inline: <<-SHELL
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
    SHELL
  end

  config.vm.define "dev" do |dev|
    dev.vm.box = "bento/ubuntu-18.04"
    dev.vm.synced_folder "./config", "/vagrant_config"
    dev.vm.network "private_network", ip: "192.168.50.6"
    dev.vm.hostname = "dev"

    dev.ssh.insert_key = false # 1
    # как было
    # dev.ssh.private_key_path = ['~/.ssh/ansible', '~/.vagrant.d/insecure_private_key'] # 2
    # dev.vm.provision "file", source: "~/.ssh/ansible.pub", destination: "~/.ssh/authorized_keys" # 3

    dev.ssh.private_key_path = ['./config/ansible/ansible_ssh_key', '~/.vagrant.d/insecure_private_key'] # 2
    dev.vm.provision "file", source: "./config/ansible/ansible_ssh_key.pub", destination: "~/.ssh/authorized_keys" # 3

    dev.vm.provision "shell", inline: <<-SHELL
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
    SHELL
  end
end
