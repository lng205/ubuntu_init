#!/bin/bash

main() {
    setup_proxy $1
    setup_apt_mirror
}

setup_proxy() {
    local PROXY=$1
    local TIMEOUT=5

    # Check if proxy is valid
    if ! curl -fsx "$PROXY" --max-time $TIMEOUT google.com > /dev/null; then
        echo "Proxy is invalid or unreachable. Please try again. (e.g., http://proxy.example.com:port)"
        exit 1
    fi

    # Add proxy to environment variables
    tee -a ~/.bashrc <<EOF

export http_proxy="$PROXY"
export https_proxy="$PROXY"
EOF
    source ~/.bashrc

    # Add proxy to sudoers
    echo 'Defaults env_keep += "http_proxy https_proxy"' | sudo tee /etc/sudoers.d/proxy
    sudo chmod 440 /etc/sudoers.d/proxy
}

setup_apt_mirror() {
    echo "Setting up APT mirror source to hit..."
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
    sudo tee /etc/apt/sources.list <<EOF
deb http://mirrors.hit.edu.cn/ubuntu/ jammy main restricted universe multiverse
deb http://mirrors.hit.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse
deb http://mirrors.hit.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse
deb http://mirrors.hit.edu.cn/ubuntu/ jammy-security main restricted universe multiverse
EOF

    sudo apt update && sudo apt upgrade -y
}

main $1