#!/bin/bash

set -e

source components/common.sh

COMPONENT=mongodb

echo -n "configuring the ${COMPONENT} repos: "
curl -s -o /etc/yum.repos.d/${COMPONENT}.repo https://raw.githubusercontent.com/stans-robot-project/${COMPONENT}/main/mongo.repo 

stat $?

echo -n "installing ${COMPONENT}: "
yum install -y mongodb-org >> /tmp/${COMPONENT}.log
stat $?


echo -n "Updating the mongodb Config:"
sed -i -e 's/127.0.0.1/ 0.0.0.0/' /etc/mongod.conf

echo -n "starting the service: "
systemctl enable mongod >> /tmp/${COMPONENT}.log
systemctl start mongod
stat $?

echo -n "Downloading the schema and inject it: "
curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip"
stat $?

echo -n "Extracting the mongodb Schema:"
cd /tmp && unzip -o mongodb.zip >> /tmp/mongodb.log
stat $?

echo -n "Injecting the mongodb schema: "
cd mongodb-main
mongo < catalogue.js >> /tmp/mongodb.log
mongo < users.js >> /tmp/mongodb.log
stat $?

echo -n -e "\n ******_______________________$COMPONENT Cofiguration Completed________________________********* \n"




