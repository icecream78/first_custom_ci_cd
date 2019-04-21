#!/bin/sh

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
