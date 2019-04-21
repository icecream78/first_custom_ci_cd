# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "gogs" do |gogs|
    gogs.vm.box = "ubuntu/trusty64"
    gogs.vm.synced_folder "./config/gogs", "/vagrant_config"
    gogs.vm.network "private_network", ip: "192.168.50.4"
    gogs.vm.hostname = "gogs"

    gogs.vm.provision "shell", path: "./provisions/gogs.sh"
  end

  config.vm.define "drone" do |drone|
    drone.vm.box = "bento/ubuntu-18.04"
    drone.vm.synced_folder "./config/drone", "/vagrant_config"
    drone.vm.synced_folder "./config/ansible", "/ansible"
    drone.vm.synced_folder "./config/", "/vagrant_shared"
    drone.vm.network "private_network", ip: "192.168.50.5"
    drone.vm.hostname = "deploy"

    drone.vm.provision "shell", path: "./provisions/drone.sh"
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
    dev.vm.provision "shell", path: "./provisions/dev.sh"
  end
end
