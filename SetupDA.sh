#!/bin/bash
cd /home/ubuntu/DCTM-xCP-16.4.0/media-files
sudo docker run --network dctm-dev -d --name documentum-da --hostname documentum-da -p 8080:8080 amit17051980/tomcat:7.0
sleep 2s
sudo docker cp ~/media/DCTM-xCP-16.4.0/media-files/da documentum-da:/usr/local/tomcat/webapps/
