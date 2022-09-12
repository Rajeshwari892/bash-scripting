#!/bin/bash

set -e

source components/common.sh

echo -n "configuring the mongodb repos: "
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo 

stat $?

echo -n "installing mongodb: "
yum install -y mongodb-org >> /tmp/mongodb.log
stat $?

echo -n "starting the service: "
systemctl enable mongod >> /tmp/mongodb.log
systemctl start mongod
stat $?


echo -n "Updating the mongodb Config:"
sed -i -e 's/127.0.0.1/ 0.0.0.0/' /etc/mongod.conf
#sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 

echo -n "restarting the service: "
systemctl restart mongod
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




