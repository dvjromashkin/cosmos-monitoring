#!/bin/bash

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
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker $USER

echo ""
printGreen "Downloading Node Monitoring config files" && sleep 1
cd $HOME
rm -rf cosmos_monitoring
git clone https://github.com/dvjromashkin/cosmos_monitoring.git

chmod +x $HOME/cosmos_monitoring/add_validator.sh
