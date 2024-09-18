import hcloud
from hcloud import *
from hcloud.images import Image
from hcloud.server_types import ServerType
from os import environ

import hcloud.ssh_keys

client = Client(token=environ['TF_VAR_hcloud_token'])

servers = client.servers.get_all()
pets = []
cp = []
wn = []
bastion = []
for server in servers:
    if "adrenlinerush.net" in server.name:
        pets.append(server)
    elif "k3s_cp" in server.name:
        cp.append(server)
    elif "k3s_wn" in server.name:
        wn.append(server)
    elif "bastion" in server.name:
        bastion.append(server)

print("[Pets]")
for server in pets:
    try:
      print(server.name + " " + server.public_net.ipv4.ip)
    except:
      print(server.name + " " + server.private_net[0].ip)

print("\n[k3s:control]")
for server in cp:
    print(server.name + " " + server.private_net[0].ip)

print("\n[k3s:worker]")
for server in wn:
    print(server.name + " " + server.private_net[0].ip)

print("\n[bastion]")
for server in bastion:
    print(server.name + " " + server.public_net.ipv4.ip)

