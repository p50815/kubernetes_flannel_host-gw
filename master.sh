#!/bin/bash
echo "安裝 Docker 及 kubeadm"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y docker.io kubeadm

echo "初始化 kubeadm"
kubeadm init --pod-network-cidr=10.244.0.0/16

echo "Kubernetes 初始化集群所需要的配置命令"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "部署網絡插件"
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
# "Network": "10.244.0.0/16",
# "Backend": {
#   "Type": "vxlan"
# }
# 注意要修改 Backend.Type
sed 's/vxlan/host-gw/' -i kube-flannel.yml
kubectl create -f kube-flannel.yml

echo "修改 nameserver"
systemctl disable systemd-resolved
sed 's/127.0.0.53/8.8.8.8/' -i /etc/resolv.conf

echo "Kubernetes Master 建立完成"
kubeadm token create --print-join-command
