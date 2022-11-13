#!/bin/bash

set -e

source components/common.sh

COMPONENT=rabbitmq


echo -n "Erlang dependency configuring for the $COMPONENT repo: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>> ${LOGFILE}
stat $?

echo -n "configuring and installing the $COMPONENT repo"
# curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> ${LOGFILE}
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> ${LOGFILE}
yum install rabbitmq-server -y &>> ${LOGFILE}
stat $?

echo -n "Starting $COMPONENT: "

systemctl enable rabbitmq-server &>> ${LOGFILE}
systemctl start rabbitmq-server &>> ${LOGFILE}
stat $?

#rabbitmqctl add_user roboshop roboshop123

rabbitmqctl list_users | grep roboshop &>> ${LOGFILE}
if [ $? -ne 0 ] ; then
    echo -n "Creating Applicaiton user on $COMPONENT: "
    rabbitmqctl add_user roboshop cd &>> $LOGFILE 
    stat $? 
fi 

echo -n "Configuring the $COMPONENT $FUSER permissions: "
rabbitmqctl set_user_tags roboshop administrator &>> ${LOGFILE}  &&  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> ${LOGFILE} 
stat $?

echo -e "\n ************ $Component Installation Completed ******************** \n"
