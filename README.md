# Init Helper

This repository is a collection of setting up a development environment for a new machine using ubuntu.

Current set up steps:

- Proxy
- APT mirror source
- Docker
- SSH

## USAGE

1. Run `./init.sh http://proxy.example.com:port`
2. Optional: put your ssh key in ./priv and run `./ssh.sh`
3. Run `./docker.sh`
4. Build docker image with password: `docker build -t dev --build-arg PASSWORD=[password] .`

## NOTICE

SSH key should maintain line breaking(LF/CRLF) and the trailing newline in the end of priv key file.