#!/bin/bash

#AMI_ID="ami-0d2238d1970144264" 

if [ -z  "$1" ] ; then #  z expects value; empty throws error, $1 expects the value,  if $1 value is not supplied, mark it as failure
    echo -e "\e[32m Machine name  is Missing \e[0m"
    exit 1
fi

COMPONENT=$1 #after sudo bash launch-ec2 value($1= frontend or user or catalogue)
ENV=$2

ZONEID="Z0886787287FCWEAXMAVA" 
AMI_ID=$(aws ec2 describe-images  --filters "Name=name,Values=DevOps-LabImage-CentOS7"  | jq '.Images[].ImageId'| sed -e 's/"//g')
SGID="sg-0092586f6f714fc1b"  
echo "ami id id which we are using is $AMI_ID"

create-server(){
    PRIVATE_IP=$(aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro  --security-group-ids ${SGID}  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" --instance-market-options "MarketType=spot, SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"| jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')


    echo "private ip of the created machine is $PRIVATE_IP"
    echo "Spot Instance $COMPONENT is ready: "
    echo "Creating Route53 Record . . . . :"

    sed -e "s/PRIVATEIP/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" r53.json  >/tmp/record.json 

    aws route53 change-resource-record-sets --hosted-zone-id ${ZONEID}  --change-batch file:///tmp/record.json | jq 

}
if [ "$1" == "all" ] ; then 
    for component in catalogue cart shipping mongodb payment rabbitmq redis mysql user frontend; do 
        COMPONENT=$component
        # calling function
        create-server
     done
else 
     create-server
fi 

