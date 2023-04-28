#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/staketown/utils/master/common.sh)

printGreen "Installing node-exporter" && sleep 1
# install node-exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
sudo mv node_exporter-*.*-amd64/node_exporter /usr/local/bin/
rm node_exporter-* -rf

sudo id -u node_exporter &>/dev/null || sudo useradd -rs /bin/false node_exporter

sudo tee <<EOF >/dev/null /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

printGreen "Installation finished" && sleep 1
printGreen "Please make sure ports 9100 is open" && sleep 1