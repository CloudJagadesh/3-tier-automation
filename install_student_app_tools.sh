#! /bin/bash

# sudo yum update -y
sudo systemctl stop firewalld
# sudo setsebool httpd_can_network_connect 1

sudo hostnamectl set-hostname app-server

# add the user devops
sudo useradd devops

# set password : the below command will avoid re entering the password
echo "devops" | passwd --stdin devops

# modify the sudoers file at /etc/sudoers and add entry
echo 'devops     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers

# this command is to add an entry to file : echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config
# the below sed command will find and replace words with spaces "PasswordAuthentication no" to "PasswordAuthentication yes"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart

# sudo yum install tree wget zip unzip gzip vim net-tools git bind-utils python2-pip jq -y

sudo su - devops -c "git config --global user.name 'devops'"
sudo su - devops -c "git config --global user.email 'devops@gmail.com'"

# Installing Java 11
sudo yum install java-11-amazon-corretto.x86_64 -y

sudo chown -R devops:devops /opt

cd /opt

wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
tar -xzvf apache-maven-3.9.6-bin.tar.gz
mv apache-maven-3.9.6 maven
rm -rf apache-maven-3.9.6-bin.tar.gz
sudo su - devops -c "ln -s /opt/maven/bin/mvn /usr/local/bin/mvn"

wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz
tar -xzvf apache-tomcat-9.0.85.tar.gz
rm -rf apache-tomcat-9.0.85.tar.gz
mv apache-tomcat-9.0.85 tcserver

sudo chown -R devops:devops /opt

echo  ' [UNIT]
        Description = Tomcat Server
        After=syslog.target network.target

        [Service]
        Type=forking
        User=devops
        Group=devops

        Environment=JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto.x86_64
        Environment='JAVA_OPTS=-Djava.awt.headless=true'
        Environment=CATALINA_HOME=/opt/tcserver/
        Environment=CATALINA_BASE=/opt/tcserver/
        Environment=CATALINA_PID=/opt/tcserver/temp/tomcat.pid
        Environment='CATALINA_OPTS=-Xms512M -Xmx512M'
        ExecStart=/opt/tcserver/bin/catalina.sh start
        ExecStop=/opt/tcserver/bin/catalina.sh stop

        [Install]
        WantedBy=multi-user.target ' > /etc/systemd/system/tomcat.service

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# Install Nginx
sudo yum install nginx.x86_64 -y
systemctl enable nginx
systemctl start nginx

# Installing MariaDB
sudo yum install mariadb105-server.x86_64 -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
#systemctl status mariadb

git clone https://gitlab.com/rns-app/student-app.git
git clone https://gitlab.com/rns-app/static-project.git
sudo yum install java-1.8.0-amazon-corretto-devel.x86_64 -y
