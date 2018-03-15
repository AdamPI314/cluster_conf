#!/bin/bash

# Administrator username and password on the destination node
NODE_NAME=$1
NODE_IP=$2
ADMIN_USERNAME=$3

# update ssh config file to ignore unknown host
if ! [ -d ~/.ssh ]; then
    mkdir ~/.ssh/
fi

pattern0="Host headnode"
if grep -q "${pattern0}" ~/.ssh/config; then
    echo $pattern0 found
else
    echo Host headnode >> ~/.ssh/config;
fi

pattern1="Host node"
if grep -q "${pattern1}" ~/.ssh/config; then
    echo $pattern1 found
else
    echo Host node\* >> ~/.ssh/config;
fi

pattern2="StrictHostKeyChecking no"
if grep -q "${pattern2}" ~/.ssh/config; then
    echo $pattern2 found
else
    echo StrictHostKeyChecking no >> ~/.ssh/config;
fi

pattern3="UserKnownHostsFile"
if grep -q "${pattern3}" ~/.ssh/config; then
    echo $pattern3 found
else
    echo UserKnownHostsFile=/dev/null >> ~/.ssh/config
fi

# add node ip, node name pair to /etc/hosts
pattern4="${NODE_IP} ${NODE_NAME}"
if grep -q "${pattern4}" /etc/hosts; then
    echo $pattern4 found
else
    echo ${pattern4} >> /etc/hosts
fi

# generate a set of sshkey under ~/.ssh if there is not one yet
if ! [ -f ~/.ssh/id_rsa ]; then
    ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
fi

sed -i "/\b\(${NODE_IP}\)\b/d" ~/.ssh/known_hosts

ssh-copy-id -f ${ADMIN_USERNAME}@${NODE_IP}
