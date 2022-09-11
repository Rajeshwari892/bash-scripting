# validating whether the executing user is root or not
ID=$(id -u)
if [ $ID -ne 0 ]; then # $ID we are gatting value as 1 or 2
   echo -e "\e[32m Try executing as sudo or a root user \e[0m"
   exit 1
fi;

#Declaring the function to check the executed commands success state
# if status of cmd is 1 then it is executed properly. $

stat() {
    if [ $1 -eq 0 ]; then # $1 means expecting the value  from function stat to pass; $? passing from frontend as $?( 0 if success of cmd)
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[32m Failure. check for the logs. \e[0m"
    fi
}


