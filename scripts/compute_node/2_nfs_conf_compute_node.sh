#!/bin/bash

stty sane
echo /tmp/nfs_conf_compute_node.log.$$ > /tmp/nfs_conf_compute_node.log.$$ 2>&1

# NFS setup, head node
#sudo blkid to see UUID of disk/folder
#sudo vim /etc/exports, add two lines
sudo apt-get -y install nfs-client >> /tmp/nfs_conf_compute_node.log.$$ 2>&1

str1="headnode:/ssd2t /ssd2t nfs"
pattern1="headnode:\/ssd2t \/ssd2t nfs"
if grep -q "${pattern1}" /etc/fstab; then
    echo $str1 found
else
    sudo echo $str1 >> /etc/fstab | xargs >> /tmp/nfs_conf_compute_node.log.$$ 2>&1
fi

str2="headnode:/hdd4t /hdd4t nfs"
pattern2="headnode:\/hdd4t \/hdd4t nfs"
if grep -q "${pattern2}" /etc/fstab; then
    echo $str2 found
else
    sudo echo $str2 >> /etc/fstab | xargs >> /tmp/nfs_conf_compute_node.log.$$ 2>&1
fi

str3="headnode:/home /home nfs"
pattern3="headnode:\/home \/home nfs"
if grep -q "${pattern3}" /etc/fstab; then
    echo $str3 found
else
    sudo echo $str3 >> /etc/fstab | xargs >> /tmp/nfs_conf_compute_node.log.$$ 2>&1
fi

if ! [ -d /ssd2t ]; then
	sudo mkdir /ssd2t >> /tmp/nfs_conf_compute_node.log.$$ 2>&1
fi

if ! [ -d /hdd4t ]; then
	sudo mkdir /hdd4t >> /tmp/nfs_conf_compute_node.log.$$ 2>&1
fi

if ! [ -d /home ]; then
	sudo mkdir /home >> /tmp/nfs_conf_compute_node.log.$$ 2>&1
fi

sudo mount -a >> /tmp/nfs_conf_compute_node.log.$$ 2>&1



