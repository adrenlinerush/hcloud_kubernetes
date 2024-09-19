#/bin/bash

source .env
if [ ! -d scripts/venv ]; then
  python -m venv scripts/venv
fi
source scripts/venv/bin/activate
pip install -r scripts/requirements.txt
