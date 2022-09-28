#!/bin/bash

# validating whether the executing user is root or not
ID=$(id -u)
if [ $ID -ne 0 ]; then # $ID we are gatting value as 0 or non zero
   echo -e "\e[32m Try executing as sudo or a root user \e[0m"
   exit 1
fi;

#Declaring the function to check the executed commands success state
# if status of cmd is 1 then it is executed properly. $

stat() {
    if [ $1 -eq 0 ]; then # $1 expects one value; $? passing from frontend as value( 0-if prev cmd executes crctly)
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[32m Failure. check for the logs. \e[0m"
    fi
}

FUSER=roboshop
LOGFILE=/tmp/robot.log

USER_SETUP() {
    echo -n "adding $FUSER user: "
    id $FUSER &>> LOGFILE || useradd $FUSER # Creates users only in case if the user account doen's exist
    stat $?
}

DOWNLOAD_AND_EXTRACT() {

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

    echo -n "Changing the ownership to $FUSER:"
    chown -R $FUSER:$FUSER ${COMPONENT}/
    stat $?
}



CONFIG_SVC() {
    echo -n "Configuring the systemd file"
    sed -i -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/'  -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/${FUSER}/${COMPONENT}/systemd.service 
    mv /home/${FUSER}/${COMPONENT}/systemd.service  /etc/systemd/system/${COMPONENT}.service
    stat $? 

    echo -n "Starting the service"
    systemctl daemon-reload  &>> /tmp/${COMPONENT}.log 
    systemctl enable ${COMPONENT} &>> /tmp/${COMPONENT}.log
    systemctl start ${COMPONENT} &>> /tmp/${COMPONENT}.log
    stat $?    

}

NODEJS() {
    echo -n "Configure Yum Repos for nodejs:"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash >> /tmp/${COMPONENT}.log 
    stat $?

    echo -n "Installing nodejs:"
    yum install nodejs -y >> /tmp/${COMPONENT}.log 
    stat $?

    # Calling User creation function
    USER_SETUP 

    # Calling Download and extract function
    DOWNLOAD_AND_EXTRACT

    echo -n "Installing $COMPONENT Dependencies:"
    cd $COMPONENT && npm install &>> /tmp/${COMPONENT}.log 
    stat $? 
    
    # Calling Config_SVC Function
    CONFIG_SVC    
}

MAVEN(){
    echo -n "installing Maven..this will  aslo install java"
    yum install maven -y >>  /tmp/${COMPONENT}.log
    stat $?

    USER_SETUP
    #roboshop user setup


    DOWNLOAD_AND_EXTRACT
    #downloading and extracting

    echo -n "mvn clean package.."
    cd /home/$FUSER/${COMPONENT}
    mvn clean package >> /tmp/${COMPONENT}.log
    mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar >> /tmp/${COMPONENT}.log
    stat $?

    CONFIG_SVC
}






