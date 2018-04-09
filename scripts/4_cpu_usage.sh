# #!/bin/bash

# own=$(id -nu)

# for user in $(who | awk '{print $1}' | sort -u)
# do
#     # print other user's CPU usage in parallel but skip own one because
#     # spawning many processes will increase our CPU usage significantly
#     if [ "$user" = "$own" ]; then continue; fi
#         top -bn2 -u "$user" | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk -v user=$user, '{print user 100 - $1"%"}' &
# done
# wait

# # print own CPU usage after all spawned processes completed
# top -bn2 -u "$own" | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk -v user=$own, '{print user, 100 - $1"%"}'

#!/bin/bash

# for user in $(who | awk '{print $1}' | sort -u)
for user in $(ps aux | awk '{ print $1 }' | sed '1 d' | sort -u | uniq); do
    if [[ ( getent group SkodjeLab | grep &>/dev/null "\b${user}\b" ) || ( getent group sudo | grep &>/dev/null "\b${user}\b" ) ]]; then
            # print other user's CPU usage in parallel but skip own one because
            # spawning many processes will increase our CPU usage significantly
            (ncpu=$(lscpu | grep "^CPU(s)" | awk '{print $2}'); \
                    ratio=$(echo "1.0/$ncpu" | bc -l); \
                    nline1=$(top -bn1 -u "$user" | wc -l); \
                    nline2=$(top -bn2 -u "$user" | wc -l); \
                    top -bn2 -u "$user" | tail -$(($nline2-$nline1)) | grep "$user" | awk -v user="$user" -v ratio=$ratio, '{ sum += $9; } END { print user, sum*ratio"%"; }') &
    fi
done
wait

# print own CPU usage after all spawned processes completed
top -bn2 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "OVERALL,", 100 - $1"%"}'