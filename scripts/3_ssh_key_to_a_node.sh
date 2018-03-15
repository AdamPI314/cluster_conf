#!/bin/bash

# Administrator username and password on the destination node
ADMIN_USERNAME=$1
NODE_IP=$2

# update ssh config file to ignore unknown host
if ! [ -d ~/.ssh ]; then
    mkdir ~/.ssh/
fi

# generate a set of sshkey under ~/.ssh if there is not one yet
if ! [ -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
fi

sed -i "/\b\(${NODE_IP}\)\b/d" ~/.ssh/known_hosts

ssh-copy-id -f ${ADMIN_USERNAME}@${NODE_IP}
