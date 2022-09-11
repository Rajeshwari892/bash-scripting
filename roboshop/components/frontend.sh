
set -e # to stop execution of further steps at the point of failure 

source components/common.sh

#install nginx
echo -n "install nginx: " # -n is used to get the commands in next line

yum install nginx -y  >> /tmp/frontend.log

systemctl enable nginx

echo -n "starting nginx: "
systemctl start nginx
stat $?

echo -n "Downloading the Code"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "Downloading the Code: "
 cd /usr/share/nginx/html
 rm -rf *
 unzip /tmp/frontend.zip >> /tmp/frontend.logs
 mv frontend-main/* .
 mv static/* .
 rm -rf frontend-main README.md
 mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -n "restarting the service: "

 systemctl daemon-reload
 systemctl restart nginx


