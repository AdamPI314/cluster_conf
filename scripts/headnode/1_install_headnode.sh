#!/bin/bash

stty sane
echo /tmp/install_headnode.log.$$ > /tmp/install_headnode.log.$$ 2>&1

sudo apt-get -y update >> /tmp/install_headnode.log.$$ 2>&1
sudo apt-get -y upgrade >> /tmp/install_headnode.log.$$ 2>&1
sudo apt-get -y update >> /tmp/install_headnode.log.$$ 2>&1
sudo apt-get -y autoremove >> /tmp/install_headnode.log.$$ 2>&1

# NFS setup, head node
sudo apt-get -y install nfs-server >> /tmp/install_headnode.log.$$ 2>&1

sudo apt-get -y upgrade >> /tmp/install_headnode.log.$$ 2>&1
sudo apt-get -y update >> /tmp/install_headnode.log.$$ 2>&1
sudo apt-get -y autoremove >> /tmp/install_headnode.log.$$ 2>&1
