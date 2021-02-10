#curl -fL https://get.k3s.io | K3S_TOKEN={{K3S_TOKEN}} INSTALL_K3S_CHANNEL=stable sh -s - --cluster-init  --node-ip {{ NODE_IP }} --kube-apiserver-arg default-not-ready-toleration-seconds=10 --kube-apiserver-arg default-unreachable-toleration-seconds=10 --disable traefik --disable servicelb
curl -fL https://get.k3s.io | INSTALL_K3S_VERSION=v1.19.7+k3s1 K3S_TOKEN={{K3S_TOKEN}} sh -s - --cluster-init  --node-ip {{ NODE_IP }} --kube-apiserver-arg default-not-ready-toleration-seconds=10 --kube-apiserver-arg default-unreachable-toleration-seconds=10 --disable traefik --disable servicelb

