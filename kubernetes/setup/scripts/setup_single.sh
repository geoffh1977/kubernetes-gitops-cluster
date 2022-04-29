#!/bin/bash
apt install -y python3-kubernetes
ansible-galaxy collection install kubernetes.core
ansible-playbook ./setup_single.yaml
ansible-playbook ./setup_cluster.yaml
