#!/bin/bash

set -e

source components/common.sh

echo -n "configure yum Repos for nodejs:  "
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
stat $?

echo -n "installing NodeJS: "
yum install nodejs -y >> /tmp/catalogue.log
stat $?

echo -n "adding roboshop user: "
id roboshop >> /tmp/catalogue.log || useradd roboshop # Creates users only in case if the user account doen's exist
stat $?

echo -n "Downloading the  catalogue"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip" >>  /tmp/catalogue.log

echo -n "cleanup of old catalogue content: "
rm -rf /home/roboshop/catalogue >> /tmp/catalogue.log
stat $?

echo -n "Extracting catalogue content: "
cd /home/roboshop >> /tmp/catalogue.log
unzip -o /tmp/catalogue.zip >> /tmp/catalogue.log && mv catalogue-main catalogue >> /tmp/catalogue.log
stat $?

echo -n "Changing the ownership to roboshop:"
chown -R roboshop:roboshop catalogue/
stat $?

echo -n "Installing catalogue Dependencies: "
cd catalogue && npm install &>> /tmp/catalogue.log
stat $?



