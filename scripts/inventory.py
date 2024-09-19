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
    elif "k3s-cp" in server.name:
        cp.append(server)
    elif "k3s-wn" in server.name:
        wn.append(server)
    elif "bastion" in server.name:
        bastion.append(server)
print("[ansible]")
print("localhost")
print("\n[pets]")
for server in pets:
    try:
      print(server.name + " ansible_host=" + server.public_net.ipv4.ip)
    except:
      print(server.name + " ansible_host=" + server.private_net[0].ip)

print("\n[k3s]")
print("\n[k3s:children]")
print("controlers\nworkers")
print("\n[controlers]")
for server in cp:
    print(server.name + " ansible_host=" + server.private_net[0].ip + " ansible_user=root")

print("\n[workers]")
for server in wn:
    print(server.name + " ansible_host=" + server.private_net[0].ip + " ansible_user=root")

print("\n[bastion]")
for server in bastion:
    print(server.name + " ansible_host=" + server.public_net.ipv4.ip + " ansible_user=root")
    print("\n[k3s:vars]")
    print("ansible_ssh_common_args='-o ProxyJump=root@"+server.public_net.ipv4.ip+" -o StrictHostKeyChecking=no'")
