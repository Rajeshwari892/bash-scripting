#!/bin/bash

set -e

source components/common.sh

COMPONENT=shipping
FUSER=roboshop
LOGFILE=robot.log

    echo -n "installing Maven..this will  aslo install java"
    yum install maven -y >>  /tmp/${COMPONENT}.log
    stat $?

    echo -n "adding $FUSER user: "
    id $FUSER &>> LOGFILE || useradd $FUSER # Creates users only in case if the user account doen's exist
    stat $?


    echo -n "Downloading the ${COMPONENT}: "
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/stans-robot-project/${COMPONENT}/archive/main.zip" >>  /tmp/${COMPONENT}.log
    stat $?

    echo -n "cleanup of old ${COMPONENT} content: "
    rm -rf /home/$FUSER/${COMPONENT} >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "Extracting ${COMPONENT} content: "
    cd /home/$FUSER >> /tmp/${COMPONENT}.log
    unzip -o /tmp/${COMPONENT}.zip >> /tmp/${COMPONENT}.log && mv ${COMPONENT}-main ${COMPONENT} >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "mvn clean package.."
    cd ${COMPONENT}
    mvn clean package >> /tmp/${COMPONENT}.log
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar >> /tmp/${COMPONENT}.log
    stat $?

    echo -n "configuring systemd file with cart and mysql serverip: "
    sed -i -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/'  /home/${FUSER}/${COMPONENT}/systemd.service
    mv /home/${FUSER}/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service

    echo -n "Starting the service: "
    systemctl daemon-reload  &>> /tmp/${COMPONENT}.log 
    systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
    systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
    stat $? 