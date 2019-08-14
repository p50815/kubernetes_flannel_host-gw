#!/bin/bash
echo "安裝 Docker 及 kubeadm"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y docker.io kubeadm

echo "修改 nameserver"
systemctl disable systemd-resolved
sed 's/127.0.0.53/8.8.8.8/' -i /etc/resolv.conf
