#! /bin/bash

cd /opt/

#git clone https://gitlab.com/rns-app/student-app.git

mysql -uroot < /opt/student-app/dbscript/studentapp.sql

# Manager's App Context XML

cp /opt/student-app/tomcat/manager/context.xml /opt/tcserver/webapps/manager/META-INF

# Add User to Tomcat

cp /opt/student-app/tomcat/conf/tomcat-users.xml /opt/tcserver/conf/

# Load DB Driver

cp /opt/student-app/tomcat/lib/mysql-connector.jar /opt/tcserver/lib/

# Integrate Tomcat with DB

cp /opt/student-app/tomcat/conf/context.xml /opt/tcserver/conf/

# Restart the Tomcat SErvice

sudo systemctl stop tomcat
sudo systemctl start tomcat

# Deploying Student App

#sudo yum install java-1.8.0-openjdk-devel.x86_64 -y

cd /opt/student-app/
git pull origin master

echo 2 | sudo alternatives --config java

mvn clean package
echo '1' | sudo alternatives --config java

cp /opt/student-app/target/*.war /opt/tcserver/webapps/student.war

# Nginx static app deployment

cd /usr/share/nginx/html/

sudo rm -rf *

cd /opt/

#git clone https://gitlab.com/rns-app/static-project.git

cd static-project/iPortfolio/

sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html/

# Reverse Proxy Configuration
sudo cp /opt/student-app/nginx/nginx.conf /etc/nginx/

sudo systemctl stop nginx
sudo systemctl start nginx



