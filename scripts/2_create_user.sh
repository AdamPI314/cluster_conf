#!/bin/bash

stty sane
echo /tmp/create_user.log.$$
echo /tmp/create_user.log.$$ > /tmp/create_user.log.$$ 2>&1

USER_NAME=$1
USER_PASSWD=$2
GROUP_NAME=$3

# create user if not exists
id -u ${USER_NAME} >/dev/null 2>&1 || sudo adduser ${USER_NAME} --gecos "${USER_NAME},RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "${USER_NAME}:${USER_PASSWD}" | sudo chpasswd

# create group if not exists
getent group ${GROUP_NAME} || sudo groupadd ${GROUP_NAME}
sudo usermod -a -G ${GROUP_NAME} ${USER_NAME}

echo "user created successfull"
