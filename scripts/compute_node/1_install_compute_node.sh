#!/bin/bash

stty sane
echo /tmp/install_compute_node.log.$$ > /tmp/install_compute_node.log.$$ 2>&1

sudo apt-get -y update >> /tmp/install_compute_node.log.$$ 2>&1
sudo apt-get -y upgrade >> /tmp/install_compute_node.log.$$ 2>&1
sudo apt-get -y update >> /tmp/install_compute_node.log.$$ 2>&1
sudo apt-get -y autoremove >> /tmp/install_compute_node.log.$$ 2>&1

# NFS install, compute node
sudo apt-get -y install nfs-client >> /tmp/install_compute_node.log.$$ 2>&1

sudo apt-get -y upgrade >> /tmp/install_compute_node.log.$$ 2>&1
sudo apt-get -y update >> /tmp/install_compute_node.log.$$ 2>&1
sudo apt-get -y autoremove >> /tmp/install_compute_node.log.$$ 2>&1
