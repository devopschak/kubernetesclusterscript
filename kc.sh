#!/bin/bash
sudo apt-get update
sudo apt-get install apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial mainhttps://github.com/devopschak/kubernetesclusterscript
EOF
apt-get update -y
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
modprobe br_netfilter
sysctl -p
sudo  sysctl net.bridge.bridge-nf-call-iptables=1
apt install docker.io -y
usermod -aG docker ubuntu
systemctl restart docker
systemctl enable docker.service
apt-get install -y kubelet kubeadm kubectl kubernetes-cni
systemctl daemon-reload
systemctl start kubelet
systemctl enable kubelet.service
kubeadm init 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
kubectl get nodes
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl get pods --all-namespaces
