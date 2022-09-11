
set -e # to stop execution of further steps at the point of failure 

source components/common.sh

#install nginx
echo  -n "install nginx" # -n is used to get the commands in next line

yum install nginx -y 

systemctl enable nginx

echo -n "starting nginx"
systemctl start nginx
stat $?
