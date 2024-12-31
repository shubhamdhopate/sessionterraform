#!/bin/bash
sudo apt update -y 
sudo apt install nginx -y
systemctl enable nginx
systemctl restart nginx 
systemctl status nginx 
echo "<h1> Hello All Welcome Grocery Application </h1>" > /var/www/html/index.html 
