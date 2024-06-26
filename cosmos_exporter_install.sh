#!/usr/bin/env bash

read -p "Enter exporter service name in lower case [for example: agoric]: " SERVICE_NAME
read -p "Enter bond_denom value [for example: ubld for Agoric]: " BOND_DENOM
read -p "Enter bench_prefix value [for example: agoric for Agoric]: " BECH_PREFIX
read -p "Enter rpc_port value or hit Enter for default port [26657]: " RPC_PORT
RPC_PORT=${RPC_PORT:-26657}
read -p "Enter port value for cosmos exporter or hit Enter for default port [9300]: " COSMOS_EXPORTER_PORT
COSMOS_EXPORTER_PORT=${COSMOS_EXPORTER_PORT:-9300}
read -p "Enter grpc_port value or hit Enter for default port [9090]: " GRPC_PORT
GRPC_PORT=${GRPC_PORT:-9090}

printDilimeter
printGreen "Service name: \e[1m\e[32m$SERVICE_NAME\e[0m"
printGreen "Bond denom: \e[1m\e[32m$BOND_DENOM\e[0m"
printGreen "Bench prefix: \e[1m\e[32m$BECH_PREFIX\e[0m"
printGreen "RPC port: \e[1m\e[32m$RPC_PORT\e[0m"
printGreen "gRPC port: \e[1m\e[32m$GRPC_PORT\e[0m"
printGreen "Cosmos exporter port: \e[1m\e[32m$COSMOS_EXPORTER_PORT\e[0m"
printDelimiter
sleep 2

printGreen "Installing cosmos-exporter" && sleep 1
FILE=/usr/bin/cosmos-exporter
if [ ! -f "$FILE" ]; then
    # install cosmos-exporter
    wget https://github.com/solarlabsteam/cosmos-exporter/releases/download/v0.3.0/cosmos-exporter_0.3.0_Linux_x86_64.tar.gz
    tar xvfz cosmos-exporter*
    sudo cp ./cosmos-exporter /usr/bin
    rm cosmos-exporter* -rf

    sudo id -u cosmos_exporter &>/dev/null || sudo useradd -rs /bin/false cosmos_exporter
else
  printGreen "Cosmos-exporter has already installed!"
fi

printDelimiter
printGreen "Setup service: cosmos-${SERVICE_NAME}-exporter.service"

sudo tee <<EOF >/dev/null /etc/systemd/system/cosmos-${SERVICE_NAME}-exporter.service
[Unit]
Description=Cosmos ${SERVICE_NAME^} Exporter
After=network-online.target

[Service]
User=cosmos_exporter
Group=cosmos_exporter
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=cosmos-exporter --denom ${BOND_DENOM} --denom-coefficient 1000000 --bech-prefix ${BECH_PREFIX} --tendermint-rpc http://localhost:${RPC_PORT} --node localhost:${GRPC_PORT} --listen-address :${COSMOS_EXPORTER_PORT}
Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable cosmos-${SERVICE_NAME}-exporter
sudo systemctl start cosmos-${SERVICE_NAME}-exporter

printGreen "Installation finished" && sleep 1
printGreen "Please make sure ports $COSMOS_EXPORTER_PORT is open" && sleep 1
