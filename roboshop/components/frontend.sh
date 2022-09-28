
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

cd /usr/share/nginx/html
rm -rf *

echo -n "Extract the zip file: "
unzip /tmp/frontend.zip >> /tmp/frontend.log
stat $?
mv frontend-main/* .
mv static/* .
echo -n "performing cleanup: "
rm -rf frontend-main README.md
stat $?

echo -n "Configuring the Reverse Proxy: "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "update the proxy file in Nginx with the CATALOGUE, CART, USER server IP Address in the FRONTEND Server: "

for component in catalogue user cart shipping payment; do
    sed -i -e "/${component}/s/localhost/${component}.roboshop.internal/"  /etc/nginx/default.d/roboshop.conf
    stat $?
done



echo -n "restarting the service: "
systemctl daemon-reload
systemctl restart nginx
stat $?
