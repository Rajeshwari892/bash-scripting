#!/bin/bash

#AMI_ID="ami-0d2238d1970144264" 




AMI_ID=$(aws ec2 describe-images --filterS "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImagesId' | sed -e 's/"//g')
echo -n "ami-id id which we are using is: " $AMI_ID

