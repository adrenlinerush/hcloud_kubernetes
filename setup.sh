#/bin/bash

ansible-galaxy collection install kubernetes.core community.dns
ANSIBLE_STDOUT_CALLBACK=yaml

source .env-devl
if [ ! -d scripts/venv ]; then
  python -m venv scripts/venv
fi
source scripts/venv/bin/activate
pip install -r scripts/requirements.txt


export HTPASSWD=$(docker run --entrypoint htpasswd registry:2.7.0 -Bbn ${REGISTRY_USER} ${REGISTRY_PASSWD})

