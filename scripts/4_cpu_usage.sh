#!/bin/bash

own=$(id -nu)

for user in $(who | awk '{print $1}' | sort -u)
do
    # print other user's CPU usage in parallel but skip own one because
    # spawning many processes will increase our CPU usage significantly
    if [ "$user" = "$own" ]; then continue; fi
        top -bn2 -u "$user" | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk -v user=$user, '{print user 100 - $1"%"}' &
done
wait

# print own CPU usage after all spawned processes completed
top -bn2 -u "$own" | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk -v user=$own, '{print user, 100 - $1"%"}'

# #!/bin/bash

# for user in $(who | awk '{print $1}' | sort -u)
# do
#     # print other user's CPU usage in parallel but skip own one because
#     # spawning many processes will increase our CPU usage significantly
#         top -bn2 -u "$user" | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk -v user=$user, '{print user, 100 - $1"%"}' &
# done
# wait

# # print own CPU usage after all spawned processes completed
# top -bn2 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "OVERALL,", 100 - $1"%"}'