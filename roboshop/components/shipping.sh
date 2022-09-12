#!/bin/bash

set -e

source components/common.sh

COMPONENT=shipping
FUSER=roboshop
LOGFILE=robot.log

    echo -n "installing Maven..this will  aslo install java"
    yum install maven -y
    $?

    echo -n "adding $FUSER user: "
    id $FUSER &>> LOGFILE || useradd $FUSER # Creates users only in case if the user account doen's exist
    stat $?


    DOWNLOAD_AND_EXTRACT

    echo -n "mvn clean package.."
    cd ${COMPONENT}
    mvn clean package 
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar
    stat $?

    echo -n "configuring systemd file with cart and mysql serverip"
    sed -i -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal'  /home/${FUSER}/${COMPONENT}/systemd.service
    mv /home/${FUSER}/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service
    
    echo -n "Starting the service: "
    systemctl daemon-reload  &>> /tmp/${COMPONENT}.log 
    systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
    systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
    stat $? 
    stat $? 