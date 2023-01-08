#!/bin/bash

## !IMPORTANT ##
#
## This script is tested only in the generic/ubuntu2004 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again
#

echo "[TASK 1] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 3] Enable and Load Kernel modules"
cat >>/etc/modules-load.d/containerd.conf<<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter

echo "[TASK 4] Add Kernel settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF
sysctl --system >/dev/null 2>&1

echo "[TASK 5] Add dependencies Docker"
apt update -qq >/dev/null 2>&1
apt-get install ca-certificates curl gnupg lsb-release >/dev/null 2>&1

echo "[TASK 6] Add GPG Key Docker"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "[TASK 7] Add apt repo for Docker"
curl -s https://download.docker.com/linux/ubuntu/gpg | apt-key add - >/dev/null 2>&1
apt-add-repository "deb https://download.docker.com/linux/ubuntu focal stable" >/dev/null 2>&1

echo "[TASK 8] Update Repository"
sudo apt-get update

echo "[TASK 9] Install Docker"
sudo apt-get install docker docker.io docker-ce docker-ce-cli containerd

echo "[TASK 10] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 11] Set root password"
echo -e "rancher\rancher" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[TASK 12] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.56.100  master.jhonthan.tech    web
192.168.56.101  master.jhonthan.tech    master
192.168.56.102  worker1.jhonthan.tech    worker1
192.168.56.103  worker2.jhonthan.tech    worker2
EOF