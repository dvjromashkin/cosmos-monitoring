#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/staketown/utils/master/common.sh)

printLogo

echo ""
printGreen "Updating dependencies" && sleep 1
sudo apt-get update

echo ""
printGreen -e "Installing required dependencies" && sleep 1
sudo apt install jq -y
sudo apt install python3-pip -y
sudo pip install yq

echo ""
printGreen "Install Docker and docker compose" && sleep 1
bash <(curl -s https://raw.githubusercontent.com/staketown/utils/master/docker-install.sh)


echo ""
printGreen "Downloading Node Monitoring config files" && sleep 1
cd $HOME
rm -rf cosmos_monitoring
git clone https://github.com/staketown/cosmos_monitoring.git

chmod +x $HOME/cosmos_monitoring/add_validator.sh
