#cloud-config
packages:
  - curl
runcmd:
  - apt-get update -y
  - curl https://get.k3s.io | K3S_TOKEN=${k3s_cluster_token} sh -s - server --cluster-init --tls-san=10.0.1.2
