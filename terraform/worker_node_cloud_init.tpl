#cloud-config
packages:
  - curl
runcmd:
  - apt-get update -y
  - until curl -k https://10.0.1.2:6443; do sleep 5; done
  - curl https://get.k3s.io | K3S_URL=https://10.0.1.2:6443 K3S_TOKEN=${k3s_cluster_token} sh - 
