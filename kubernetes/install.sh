#!/bin/bash

# Installs Kubernetes And Copies Setup Files

# This Script Should Be Executed As Root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!"
   echo 
   exit 1
fi

gitRepo="https://raw.githubusercontent.com/geoffh1977/kubernetes-gitops-cluster/main/kubernetes/setup"
k8sInstallDir="/tmp/k8s-install"

# Check And Wait For Internet Connection
loopCount=0
connectStatus=999
while [ $connectStatus -ne 0 ]
do
  ((loopCount++))
  sleep 1
  if curl -s -o /dev/null http://google.com/
  then
    connectStatus=0
  fi
  if [ $loopCount -eq 60 ]
  then
    echo " ERROR: No Internet Connection. Unable To Install Kubernetes!"
    exit 1
  fi
done

# Install Ansible and Curl so the set up script can execute
apt install -y ansible curl python3-apt

# Download Files For Kubernetes Installation
[ -d "${k8sInstallDir}" ] && rm -rf "${k8sInstallDir}"
mkdir "${k8sInstallDir}"
for G in master-playbook install-prerequisites install-docker install-containerd install-kubernetes setup_cluster setup_k8s_master
do
  curl -s -o "${k8sInstallDir}/${G}.yaml" "${gitRepo}/ansible/${G}.yaml"
done

# Instal The Packages For Kubernetes
currentDir="${PWD}"
cd "${k8sInstallDir}"
ansible-playbook master-playbook.yaml
cd "${currentDir}"

# Clean Up Install Files
rm -rf "${k8sInstallDir}"
if [ -f /usr/bin/kubectl ]
then
  systemctl disable kubernetes_install.service
  rm -rf /etc/systemd/system/kubernetes_install.service
  rm -f /root/k8s-install.sh
fi
