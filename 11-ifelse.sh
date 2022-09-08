#!/bin/bash
#  [ -z "$var" ]
# [ -n "$var" ]

# ACTION=$1 

# Demo On If Else 
# if [ "$ACTION" = "start" ] ; then 
#     echo "Selected choice is start"

# else 
#     echo "Only valid option is start"
# fi 


# Demo on Else If  & usecase ofn exit codees 

# if [ "$ACTION" = "start" ] ; then 
#     echo "Starting XYZ Service"
#     uptime 

#     elif [ "$ACTION" = "stop" ] ; then 
#         echo "Stopping XYZ Service" 
#         exit 1 

#     elif [ "$ACTION" = "restart" ] ; then 
#         echo "Restarting XYZ Service" 
#         exit 2
#     else 
#         echo -e "Valid options are \e[31m start or stop or restart only \e[0m" 
#         exit 3
# fi 


ACTION=$1 

if [ -z $ACTION ]; then  # -z is not comparing with anything but expecting some value as argument..
    echo "Argument is needed, Either start or stop are valid"
    exit 1
fi 



<<COMMENT a=$1 #no spaces after "="

if [ "$a" == "true" ]; then # space is required after ans before "["
    echo true condition is executed

    elif [ "$a" == "false" ];  then # if $1 entering value is string then it should be in quote either here or else in input
    echo false statement is executed

    else
    echo "no statement is executed"
    fi;
COMMENT

  
