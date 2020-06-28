#!/bin/bash
cd /home/ubuntu/DCTM-xCP-16.4.0/media-files
sudo docker run --network dctm-dev -d --name documentum-xcp --hostname documentum-xcp -p 8000:8080 amit17051980/dctm-tomcat:latest
sleep 3s
sudo docker cp context.xml documentum-xcp:/usr/local/tomcat/webapps/manager/META-INF/
sudo docker cp catalina.properties documentum-xcp:/usr/local/tomcat/conf/
sudo docker cp tomcat-users.xml documentum-xcp:/usr/local/tomcat/conf/
sudo docker cp custom-conf documentum-xcp:/usr/local/tomcat/
sudo docker restart documentum-xcp
sleep 3s
sudo docker exec documentum-xcp su -c "cp -r /usr/local/tomcat/webapps.dist/manager /usr/local/tomcat/webapps/"
