#!/bin/bash

id=$(id -u)

if [ id -eq 0 ]; then
    echo "install httpd"
    yum install httpd -y
else
    echo "try executing as a root or sudo"
fi