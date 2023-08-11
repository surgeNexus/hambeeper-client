#!/bin/bash

# installNode By Steven de Salas

# Based on script by Richard Stanley @ https://github.com/audstanley/Node-MongoDb-Pi/
# This is for a RaspberryPi Zero but should work across all models.

VERSION=v16.3.0;

# Creates directory for downloads, and downloads node
cd ~/ && mkdir temp && cd temp;
wget https://unofficial-builds.nodejs.org/download/release/$VERSION/node-$VERSION-linux-armv6l.tar.gz;
tar -xzf node-$VERSION-linux-armv6l.tar.gz;
# Remove the tar after extracing it.
sudo rm node-$VERSION-linux-armv6l.tar.gz;
# This line will clear existing nodejs
sudo rm -rf /opt/nodejs;
# This next line will copy Node over to the appropriate folder.
sudo mv node-$VERSION-linux-armv6l /opt/nodejs/;
# Remove existing symlinks
sudo unlink /usr/bin/node;
sudo unlink /usr/sbin/node;
sudo unlink /sbin/node;
sudo unlink /usr/local/bin/node;
sudo unlink /usr/bin/npm;
sudo unlink /usr/sbin/npm;
sudo unlink /sbin/npm;
sudo unlink /usr/local/bin/npm;
sudo unlink /usr/bin/npx;
sudo unlink /usr/sbin/npx;
sudo unlink /sbin/npx;
sudo unlink /usr/local/bin/npx;
# Create symlinks to node && npm && npx
sudo ln -s /opt/nodejs/bin/node /usr/bin/node;
sudo ln -s /opt/nodejs/bin/node /usr/sbin/node;
sudo ln -s /opt/nodejs/bin/node /sbin/node;
sudo ln -s /opt/nodejs/bin/node /usr/local/bin/node;
sudo ln -s /opt/nodejs/bin/npm /usr/bin/npm;
sudo ln -s /opt/nodejs/bin/npm /usr/sbin/npm;
sudo ln -s /opt/nodejs/bin/npm /sbin/npm;
sudo ln -s /opt/nodejs/bin/npm /usr/local/bin/npm;
sudo ln -s /opt/nodejs/bin/npx /usr/bin/npx;
sudo ln -s /opt/nodejs/bin/npx /usr/sbin/npx;
sudo ln -s /opt/nodejs/bin/npx /sbin/npx;
sudo ln -s /opt/nodejs/bin/npx /usr/local/bin/npx;

### Script below written by Jordan Webb https://github.com/surgeNexus/ ###

sudo apt install python3-pip git
sudo pip3 install flask
sudo pip3 install dotenv
sudo pip3 install socketio 
sudo pip3 install requests
sudo pip3 install requests

sudo mkdir /etc/hambeeper
sudo cd /etc/hambeeper
sudo git clone https://github.com/surgeNexus/hambeeper-client.git

sudo touch .env

sudo read -p 'Please enter your Node ID: ' cliRic
sudo read -p "Is the Node ID $cliRic correct? (yes/no) " yn
case $yn in 
	yes ) echo ok, we will proceed;;
	no ) read -p 'Please enter your Node ID: ' cliRic
esac

sudo read -p 'Please enter your Node Password: ' password
sudo read -p "Is the Node Password $password correct? (yes/no) " yn
case $yn in 
	yes ) echo ok, we will proceed;;
	no ) read -p 'Please enter your Node Password: ' password
esac

sudo echo "PORT=3001" > .env
sudo echo "SOCKET_URL=https://hambeeper.decad3.com" > .env
sudo echo "CLI_RIC=$cliRic" > .env
sudo echo "CLI_PASS=$password" > .env

sudo touch /etc/systemd/system/hambeeper.service

sudo echo "[Unit]" > hambeeper.service
sudo echo "Description=Ham Beeper Service" > hambeeper.service
sudo echo "After=multi-user.target" > hambeeper.service
sudo echo "[Service]" > hambeeper.service
sudo echo "Type=simple" > hambeeper.service
sudo echo "Restart=always" > hambeeper.service
sudo echo "ExecStart=/usr/bin/python3 /etc/hambeeper/hamBeeper.py" > hambeeper.service
sudo echo "[Install]" > hambeeper.service
sudo echo "WantedBy=multi-user.target" > hambeeper.service

sudo systemctl daemon-reload
sudo systemctl enable hambeeper.service
sudo systemctl start hambeeper.service