FROM ubuntu:latest
CMD ["sleep", "infinity"]

# Set apt source to Tsinghua mirror
RUN apt-get update && apt-get install -y ca-certificates
RUN tee /etc/apt/sources.list.d/ubuntu.sources <<EOF
Types: deb
URIs: https://mirrors.tuna.tsinghua.edu.cn/ubuntu
Suites: noble noble-updates noble-backports
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg

Types: deb
URIs: http://security.ubuntu.com/ubuntu/
Suites: noble-security
Components: main restricted universe multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
EOF
RUN apt update && \
    apt upgrade -y

# Install basic tools
RUN apt install -y \
    net-tools \
    vim \
    iputils-ping \
    curl \
    wget \
    git \
    sudo \
    unzip


# User setup
ARG USERNAME=yb

# Add custom user
RUN useradd --create-home --shell /bin/bash $USERNAME && \
    usermod -aG sudo $USERNAME && \
    echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
USER $USERNAME
WORKDIR /home/$USERNAME

# Set up git
COPY git.sh .
RUN ./git.sh && rm git.sh

# Set up git ssh
COPY ssh.sh .
COPY priv .
RUN ./ssh.sh && rm ssh.sh && rm priv