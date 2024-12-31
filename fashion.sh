#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y
systemctl enable nginx
systemctl restart nginx 
systemctl status nginx
mkdir /var/www/html/fashion
echo "<h1> Hello All Welcome fashion Application </h1>" > /var/www/html/fashion/index.html 