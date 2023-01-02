#!/bin/sh

## Update the local package
sudo apt update -y

## Install Apache2 package

if [ $(/etc/init.d/apache2 status | grep -v grep | grep 'apache2 is running' | wc -l) > 0 ]
then
 echo "Apache2 is already installed."
else
  sudo apt install apache2

fi

##check if apache2 service is running.

if [ $(/etc/init.d/apache2 status | grep -v grep | grep 'apache2 is running' | wc -l) > 0 ]
then
 echo "Apache2 is running."
else
  sudo systemctl start apache2

fi


## check if apache2 service is enabled

if [ $(/etc/init.d/apache2 status | grep -v grep | grep 'apache2 is running' | wc -l) > 0 ]
then
 echo "Apache2 is enabled."
else
  sudo systemctl enable apache2

fi


## Name variable
name='shailendra'

## timestamp variable
timestamp=$(date '+%d%m%Y-%H%M%S')

## S3 Bucket variable
S3bucket='upgrad-shailendra'

## Create tar file and store it to Tmp folder
tar -zcvf /tmp/"$name-httpd-logs-$timestamp".tar /var/log/apache2/*.log

## Upload the tar to S3 bucket
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${S3bucket}/${name}-httpd-logs-${timestamp}.tar


##check if inventory.html is avalable else create it

FILE=/var/www/html/inventory.html
if [ -f "$FILE" ]; then
    echo "$FILE exists."
else 
	echo  "Log Type\tTime Created\tType\tSize" >/var/www/html/inventory.html
fi

## find the size of the archive file
filesize=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{ print $1}')

## log into inventory.html
echo  "httpd-logs\t$timestamp\ttar\t$filesize" >> /var/www/html/inventory.html

## Create scheduler for everyday morning 10 AM "00 10 * * * bash /root/Automation_Project/automation.sh"
CronFile=/etc/cron.d/Cron_Automation
if [ -f "$CronFile" ]; then
    echo "$CronFile exists."
else
    sudo touch /etc/cron.d/Cron_Automation
    sudo echo "00 10 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/Cron_Automation
fi
