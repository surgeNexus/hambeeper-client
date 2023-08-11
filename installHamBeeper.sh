#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
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
# Install Python dependencies
sudo apt update -y
sudo apt install -y python3 python3-pip git
sudo pip3 install flask
sudo pip3 install python-dotenv
sudo pip3 install python-socketio
sudo pip3 install python-requests
# Create the hambeeper directory
sudo mkdir /etc/hambeeper
cd /etc/hambeeper
# Clone the hambeeper-client repository
sudo git clone https://github.com/surgeNexus/hambeeper-client.git
# Check if the .env file exists
if [ ! -f ".env" ]; then
  echo "Creating .env file..."
  touch .env
fi

# Get the user input for the Node ID
echo "Enter your Node ID:"
read CLI_RIC

# Get the user input for the Node Password
echo "Enter your Node Password:"
read CLI_PASS

# Confirm the user input
echo "Are you sure you want to write the following environment variables to the file?"
echo "CLI_RIC=$CLI_RIC"
echo "CLI_PASS=$CLI_PASS"
read -p "(Y/N) " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
  # Write the environment variables to the file
  echo "CLI_RIC=$CLI_RIC" >> .env
  echo "CLI_PASS=$CLI_PASS" >> .env

  echo "Environment variables written to file."
else
  echo "Environment variables not written to file."
  echo "Please try again."
fi

#Write the .env file
echo "PORT=3001" >> .env
echo "SOCKET_URL=https://hambeeper.decad3.com" >> .env

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
