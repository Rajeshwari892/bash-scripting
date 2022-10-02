#!/bin/bash

#AMI_ID="ami-0d2238d1970144264" 

if [ -z  "$1" ] ; then # $1 expects the value,  if $1 value is not supplied, mark it as failure
    echo -e "\e[32m Machine name  is Missing \e[0m"
    exit 1
fi

COMPONENT=$1 #after sudo bash launch-ec2 value($1= frontendor user or catalogue), z expects value; empty throws error

AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7" |  jq '.Images[].ImageId'| sed -e 's/"//g')
SGID="sg-0092586f6f714fc1b"  
echo "ami id id which we are using is $AMI_ID"

aws ec2 run-instances --image-id {$AMI_ID} --count 1 --instance-type t2.micro --security-group-ids ${SGID} --tag-specifications "ResourceType=instance,Tags=[{Key=webserver,Value=production}]" 