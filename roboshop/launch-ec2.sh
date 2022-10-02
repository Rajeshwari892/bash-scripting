#AMI_ID="ami-0d2238d1970144264" 
if [ z  "$1" ]; then # $1 expects the value, after sudo bash launch-ec2  value($1= frontendor user or catalogue), z expects value; empty throws error
    echo -e "\e[32m Machine name  is Missing \e[0m"
    exit 1
fi




AMI_ID=$(aws ec2 describe-images --filterS "Name=name,Values=DevOps-LabImage-CentOS7" | jq '.Images[].ImagesId' | sed -e 's/"//g')
echo -n "ami-id id: " $AMI_ID

