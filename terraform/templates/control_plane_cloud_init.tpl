#cloud-config
packages:
  - curl
runcmd:
  - apt-get update -y
  - echo "10.0.1.2 registry.${domain_name}" >> /etc/hosts
  - echo "nameserver 4.2.2.1" > /etc/resolv.conf
  - echo "nameserver 8.8.8.8" >> /etc/resolv.conf
  - ip route add default via 10.0.1.1
  - until curl https://google.com; do sleep 5; done
  - curl https://get.k3s.io | K3S_TOKEN=${k3s_cluster_token} sh -s - server --cluster-init
