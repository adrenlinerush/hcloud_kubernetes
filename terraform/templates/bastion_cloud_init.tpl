#cloud-config
packages:
  - curl
write_files:
  - path: /root/.ssh/id_rsa
    content: |
      ${indent(6, id_rsa)}
    permissions: "0600"
  - path: /root/nginx.yaml
    content: |
      ${indent(6, nginx_ingress)}
    permissions: "0600"
runcmd:
  - iptables -t nat -A POSTROUTING -s '10.0.1.0/24' -o eth0  -j MASQUERADE
  - echo 1 > /proc/sys/net/ipv4/ip_forward
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
  - kubectl apply -f /root/nginx.yaml
  - kubectl -n kube-system apply -f https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/download/v1.13.2/ccm-networks.yaml
  - kubectl -n kube-system create secret generic hcloud --from-literal=token=${k3s_cluster_token}
