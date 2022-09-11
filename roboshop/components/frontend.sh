
set -e # to stop execution of further steps at the point of failure 

source components/common.sh

#install nginx

systemctl enable nginx
systemctl enable nginx
systemctl start nginx
