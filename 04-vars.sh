#!/bin/bash  

a=10 
# a is 10 and is integer 

b=abc 
# abc is a string  

d=150

DATE_COMMAND=$(date +%F)
LOGGEDIN_USERS=$(who | wc -l)

#### No Datatypes in bash scriptng. Everything is a string by default.

echo value of a is : $a 
echo ${a}
echo "${a}"

echo value of d is : $d 

# rm -rf  /data/${DIR}  
# rm -rf /data/

DATE=2022-09-05
echo "Good Morning, Todays date is $DATE_COMMAND"
# This is how we can fetch the system data
echo "Number of logged in users are: $LOGGEDIN_USERS"