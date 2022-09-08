#!/bin/bash 

#syntax
# case $var  in 
#     cond1)
#         command1 ;; 
#     cond2)
#         command2 ;;
#     *)
#         exz ;;;
# esac

action = $1
#read action // read or dollar any thing can be selected.
case "$action" in
    start)
        echo "start the service"
        ;;
    end)
        echo end the servie
        ;;
    *)
        echo "\e[32m Valid options are start or stop or restart only \e[0m"
        ;;
    esac
