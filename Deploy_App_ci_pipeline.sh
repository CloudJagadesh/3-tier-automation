sudo setsebool -P httpd_can_network_connect 1
# git pull origin master
mysql -uroot < ./dbscript/studentapp.sql

# Manager's App Context XML
sudo su devops -c "cp ./tomcat/manager/context.xml /opt/appserver/webapps/manager/META-INF"

# Add User to Tomcat
sudo su devops -c "cp ./tomcat/conf/tomcat-users.xml /opt/appserver/conf/"

# Load DB Driver
sudo su devops -c "cp ./tomcat/lib/mysql-connector.jar /opt/appserver/lib/"

# Integrate Tomcat with DB
sudo su devops -c "cp ./tomcat/conf/context.xml /opt/appserver/conf/"

# Deploy the war file
sudo su devops -c "cp ./target/*.war /opt/appserver/webapps/student.war"

# Restart the Tomcat SErvice
sudo systemctl stop tomcat
sleep 30
sudo systemctl start tomcat

# -------------------------------------------------------
# Nginx static app deployment

cd /usr/share/nginx/html/

sudo rm -rf *

cd /opt/

cd static-project/iPortfolio/

sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html/

# Reverse Proxy Configuration

sudo cp ${WORKSPACE}/nginx/nginx.conf /etc/nginx/

sudo systemctl stop nginx
sleep 10
sudo systemctl start nginx
