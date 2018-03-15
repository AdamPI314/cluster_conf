#!/bin/bash

# distribute ssh key from headnode to other nodes

# Basic info
date > /tmp/ssh_key_distribute.log.$$ 2>&1
whoami >> /tmp/ssh_key_distribute.log.$$ 2>&1
echo $@ >> /tmp/ssh_key_distribute.log.$$ 2>&1

# Administrator username and password
ADMIN_USERNAME=$1
ADMIN_PASSWORD=$2

# Name and IP from file
readarray NAME_A < ../../conf/nodes_name.txt
readarray IP_A < ../../conf/nodes_ip.txt

# Parameters
MASTER_NAME=${NAME_A[0]}
MASTER_IP=${IP_A[0]}

# number of computer nodes
NUM_OF_VM=$((${#NAME_A[@]}-1))
# array of worker node names, worker node ip
# slice from 1 to the end of the array
WORKER_NAME_A=("${NAME_A[@]:1}")   
WORKER_IP_A=("${IP_A[@]:1}")

# for name in ${WORKER_NAME_A[@]}; do
#     echo $name
# done
# for ip in ${WORKER_IP_A[@]}; do
#     echo $ip
# done

# Update master node
pattern1="$MASTER_IP $MASTER_NAME"
if grep -q "${pattern1}" /etc/hosts; then
   echo $pattern1 found
else
   echo $pattern1 >> /etc/hosts
fi

# Update ssh config file to ignore unknown host
# Note all settings are for sohr, NOT root

if ! [ -d /home/$ADMIN_USERNAME/.ssh ]; then
    sudo -u $ADMIN_USERNAME sh -c "mkdir /home/$ADMIN_USERNAME/.ssh/"
fi
sudo -u $ADMIN_USERNAME sh -c "echo Host node\* > /home/$ADMIN_USERNAME/.ssh/config; echo StrictHostKeyChecking no >> /home/$ADMIN_USERNAME/.ssh/config; echo UserKnownHostsFile=/dev/null >> /home/$ADMIN_USERNAME/.ssh/config"

# Generate a set of sshkey under /home/sohr/.ssh if there is not one yet
if ! [ -f /home/$ADMIN_USERNAME/.ssh/id_rsa ]; then
    sudo -u $ADMIN_USERNAME sh -c "ssh-keygen -f /home/$ADMIN_USERNAME/.ssh/id_rsa -t rsa -N ''"
fi

# Install sshpass to automate ssh-copy-id action
sudo apt-get install sshpass -y >> /tmp/ssh_key_distribute.log.$$ 2>&1

# Loop through all worker nodes, update hosts file and copy ssh public key to it
i=0
while [ $i -lt $NUM_OF_VM ]
do
   echo 'updating host - '${WORKER_NAME_A[$i]} >> /tmp/ssh_key_distribute.log.$$ 2>&1
   
   pattern2="${WORKER_IP_A[$i]} ${WORKER_NAME_A[$i]}"
   if grep -q "${pattern2}" /etc/hosts; then
      cat /etc/hosts
      echo $pattern2 found
   else
      echo ${pattern2} >> /etc/hosts
   fi

   # for compute node
   head -n 9 /etc/hosts > /tmp/hosts.$$
   # only headnode and current node
   echo $MASTER_IP $MASTER_NAME >> /tmp/hosts.$$
   echo ${pattern2} >> /tmp/hosts.$$
   echo 'I update host - '${WORKER_NAME_A[$i]}
   sudo -u $ADMIN_USERNAME sh -c "sshpass -p '$ADMIN_PASSWORD' ssh-copy-id -f ${ADMIN_USERNAME}@${WORKER_IP_A[$i]}"
   # updates /etc/hosts on current node
   echo "updates /etc/hosts on current node..."
   sudo -u $ADMIN_USERNAME scp /tmp/hosts.$$ $ADMIN_USERNAME@${WORKER_IP_A[$i]}:/tmp/hosts >> /tmp/ssh_key_distribute.log.$$ 2>&1
   # only the first 9 lines of /etc/hosts will be kept, dump rest of that file
   sudo -u $ADMIN_USERNAME ssh $ADMIN_USERNAME@${WORKER_IP_A[$i]} >> /tmp/ssh_key_distribute.log.$$ 2>&1 <<'ENDSSH1'
   sudo sh -c "head -n 9 /etc/hosts > /etc/hosts"
   sudo sh -c "cat /tmp/hosts >> /etc/hosts"
ENDSSH1

   i=`expr $i + 1`
done
