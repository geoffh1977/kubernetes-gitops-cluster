# Kubernetes GitOps Cluster Repository

## Description

The files contained in this repository are used to builda Kubernetes Cluster which uses the principals of GitOps in order to control and manage the cluster resources. Specifically, the bootstrap scripts for this install include the following resources:

* Debian Preseed Files - Pre-configured files to be used with the Debian 11 Installation.
* Kubernetes Install - An Ansible based script which will install Kubernetes onto the built machine using kubeadm.
* Kubernetes Manifests - A set of files for Kubernetes which allows the cluster to pull projects from Git Repositories and monitor for changes. The current manifests are:
  - Calico CNI - The CNI chosen to run in the cluster to provide pod networking services. This can easily be swapped out as needed.
  - Bitnami Sealed Secrets - An operator allowing for Kubernetes Secrets to be sealed and safely stored in Git Repositories.
  - Argo CD - Argo's Continuous Deployment engine to syncronize Git Repositories and keep them in sync.

## Installation

### Physical Hardware

#### Post Installation Cluster After Clean Install

An installation script is located in the directory which will perform an installation of the binaries needed for a kubernetes host. Execute one of the following commands with root access rights in order to perform the installation after a clean install of the OS:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/geoffh1977/kubernetes-gitops-cluster/main/kubernetes/install.sh)"
```

*OR*

```bash
sh -c "$(wget https://raw.githubusercontent.com/geoffh1977/kubernetes-gitops-cluster/main/kubernetes/install.sh -O -)"
```

#### Network Installation With Pre-seed File

Installation onto Physical Hardware with the Debian Pre-seed file is possible by adding the following variables to the bootup of the Debian 11 network ISO.

```
url=https://raw.githubusercontent.com/geoffh1977/kubernetes-gitops-cluster/main/preseeds/kubernetes-master.cfg auto=true
```

### QEMU/KVM Installation With Virt Manager

Virtual Machines can be built from scratch using Debian Network Booting and the provided pre-seed files. The preseed will perform an installation of Debian 11 with common options and automatically run the installation scripts on the first boot of the operating system. The installation will only ask for the hostname/domain name and a user for the system.

```bash
virt-install --name K8s_Master --memory 4096 --vcpus 2 --disk size=20 --location http://ftp.au.debian.org/debian/dists/bullseye/main/installer-amd64/ --os-variant debian10 --extra-args="url=https://raw.githubusercontent.com/geoffh1977/kubernetes-gitops-cluster/main/preseeds/kubernetes-master.cfg auto=true" --noautoconsole
```

*N.B. You can automate the hostname/domain name setup by including netcfg/get_hostname=HOSTNAME netcfg/get_domain=MY.DOMAIN.NAME" on the above command line*

*N.B. The pre-seed files are configured for Melbourne Australia - Fork the repository and update the installation scripts to change language and other details as necessary*

## Deleting The Virtual Machine In Virt Manager

```bash
virsh undefine K8S_Master --remove-all-storage
```

