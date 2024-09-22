#cloud-config
packages:
  - curl
  - vim
write_files:
  - path: /root/.ssh/id_rsa
    content: |
      ${indent(6, id_rsa)}
    permissions: "0600"
runcmd:
  - iptables -t nat -A POSTROUTING -s '10.0.1.0/24' -o eth0  -j MASQUERADE
  - echo 1 > /proc/sys/net/ipv4/ip_forward
  - echo "10.0.1.2 registry.${domain_name}" >> /etc/hosts
  - apt-get update -y
  - curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
  - install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  - wget -q https://get.helm.sh/helm-v3.16.1-linux-arm64.tar.gz -O /root/helm.tar.gz
  - tar -zxvf /root/helm.tar.gz -C /root/
  - mv /root/linux-arm64/helm /usr/bin/helm
  - until curl -k https://10.0.1.2:6443; do sleep 5; done
  - mkdir /root/.kube
  - ssh-keyscan -H 10.0.1.2 >> /root/.ssh/known_hosts
  - scp 10.0.1.2:/etc/rancher/k3s/k3s.yaml /root/.kube/config
  - sed -i "s/127.0.0.1/10.0.1.2/g" /root/.kube/config
