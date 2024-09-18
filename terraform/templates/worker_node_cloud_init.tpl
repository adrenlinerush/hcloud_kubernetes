#cloud-config
packages:
  - curl
runcmd:
  - apt-get update -y
  - echo "nameserver 4.2.2.1" > /etc/resolv.conf
  - echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  - ip route add default via 10.0.1.1
  - until curl -k https://10.0.1.2:6443; do sleep 5; done
  - curl https://get.k3s.io | K3S_URL=https://10.0.1.2:6443 K3S_TOKEN=${k3s_cluster_token} sh - 
