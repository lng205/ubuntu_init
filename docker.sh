#!/bin/bash

main() {
    install_docker
    set_docker_proxy
    set_docker_group
}

install_docker() {
    # Add GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    if ! sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc; then
        echo "Get gpg key failed"
        exit 1
    fi

    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add apt repo
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

set_docker_proxy() {
    # systemd proxy config
    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="HTTP_PROXY=$http_proxy"
Environment="HTTPS_PROXY=$http_proxy"
EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo systemctl show --property=Environment docker

    # docker config.json proxy
    mkdir -p ~/.docker
    tee ~/.docker/config.json <<EOF
{
    "proxies": {
        "default": {
            "httpProxy": "$http_proxy",
            "httpsProxy": "$http_proxy"
        }
    }
}
EOF
}

set_docker_group() {
    sudo groupadd docker
    sudo usermod -aG docker $USER

    # Reload the shell
    newgrp docker
}

main