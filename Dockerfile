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
RUN apt install -y net-tools vim iputils-ping curl wget git

# Add custom user
RUN apt install -y adduser sudo
ARG USERNAME=yb
ARG PASSWORD
RUN adduser --disabled-password --gecos '' $USERNAME && \
    echo "$USERNAME:$PASSWORD" | chpasswd && \
    usermod -aG sudo yb
USER $USERNAME