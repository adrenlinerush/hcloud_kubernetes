#!/bin/bash

ssh -fNT -C -D 8080 "root@bastion.${TF_VAR_dns_name}"
sudo cp daemon.json /etc/docker/daemon.json
sudo systemctl restart docker
docker login -u $REGISTRY_USER -p $REGISTRY_PASSWD  "registry.${TF_VAR_dns_name}"
