#!/bin/bash

set -e

source components/common.sh

COMPONENT=rabbitmq

echo -n "Erlang dependency configuring for the $COMPONENT repo: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y  &>> ${LOGFILE} 
stat $?

echo -n "configuring and installing the $COMPONENT repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>> ${LOGFILE} 
yum install rabbitmq-server -y &>> ${LOGFILE}
stat $?

echo -n "Starting $COMPONENT"

systemctl enable rabbitmq-server &>> ${LOGFILE}
systemctl start rabbitmq-server &>> ${LOGFILE}
stat $?

#rabbitmqctl add_user roboshop roboshop123

rabbitmqctl list_users | grep roboshop 2>> ${LOGFILE}
if [ $? -ne 0 ]; then
    echo -n "Creating $COMPONENT Application user: "
    rabbitmqctl add_user roboshop roboshop123 ${LOGFILE}
    $?
fi

echo -n "Configuring the $COMPONENT $FUSER permissions: "
rabbitmqctl set_user_tags roboshop administrator &>> ${LOGFILE}  &&  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> ${LOGFILE} 
stat $?

echo -e "\n ************ $Component Installation Completed ******************** \n"
