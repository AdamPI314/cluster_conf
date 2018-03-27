#!/bin/bash

# default value, https://stackoverflow.com/questions/9332802/how-to-write-a-bash-script-that-takes-optional-input-arguments
USERNAME=${1:-Invictus}
echo "CURRENT USER: " ${USERNAME}

# Name and IP from file, have a '\n' at the end of each element
readarray -t NAME_A < ../conf/nodes_name.txt
readarray -t IP_A < ../conf/nodes_ip.txt
# mapfile -t NAME_A < ../conf/nodes_name.txt
# mapfile -t IP_A < ../conf/nodes_ip.txt

# number of computer nodes
NUM_OF_NODEs=$((${#IP_A[@]}))
echo 'TOTAL NUMBER OF NODEs: ' ${NUM_OF_NODEs}

i=0
while [ $i -lt $NUM_OF_NODEs ]
do
   echo ''
   echo 'NODE:  ' ${NAME_A[$i]}  
   RESULTS=$(ssh ${USERNAME}@${IP_A[$i]} /usr/local/bin/cpu_usage)
   echo ${RESULTS}
   
   i=`expr $i + 1`
done