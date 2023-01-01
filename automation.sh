#!/bin/sh

## Update the local package.
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

