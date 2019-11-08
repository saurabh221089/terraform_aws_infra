#!/bin/bash
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
wget http://s3.amazonaws.com/ec2metadata/ec2-metadata
sudo chmod +x ec2-metadata
sudo mv ec2-metadata /usr/local/bin
export ip=`ec2-metadata -o|cut -d " " -f 2`
echo "<html><body><h1>Hello from Webserver running on instance IP: <b>$ip</b></h1></body></html>" > /var/www/html/index.html
sudo chown -R www:www /var/www