#cloud-config
packages:
  - curl
runcmd:
  - apt-get update -y
  - until curl -k https://10.0.1.2:6443; do sleep 5; done
  - curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_cluster_token} sh -s - server --server https://10.0.1.2:6443
