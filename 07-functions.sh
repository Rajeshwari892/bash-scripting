#!/bin/bash 

# sample() {
#     echo "hai from the sample function"
#     echo "I will be printing the uptime"
#     uptime  
# }

# sample 

# Defining the function stat
stat() {
    echo "Load Average on the system from last 1 min is : $(uptime | awk -F : '{print $NF}' | awk -F , '{print $1}')"
    echo "Number of users signed in is : $(who|wc -l)" 
    echo "Stat Function is completed bye"
} 

# calling a function 
stat 
sleep 1
stat 
sleep 1
stat 
