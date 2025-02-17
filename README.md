# Auotmate_3-tier_app_using_shell_scripting

This 3-tier automation shell script helps to install App environment:
   1. Maven Build Tool
   2. Tomcat App Server
   3. Nginx Web Server
   4. Maria DB Server
   5. Git

Total 2 scripts haven implemented to complete 3 tier App deployment

Script-1:
First script helps to install the required tools and packages for 3-tier app automation:

Task-1:
         
         $ sudo su
         $ vi install_student_app_tools.sh
In the above created script apply the following steps:

Step-1: update the system:

         $ #! /bin/bash
         $ sudo yum update -y
      
Step-2: Create devops user and enable password based authentication:
      
         $ echo "devops" | passwd --stdin devops
         $ echo 'devops    ALL=(ALL)     NOPASSWD: ALL' | sudo tee -a /etc/sudoers
         $ sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
         $ service sshd restart

Step-3: We have to download some common tools for the configuration purpose:

         $ sudo yum install tree wget zip unzip gzip vim net-tools git bind-utils python3-pip jq -y

Step-4: Configure some userlevel configuration I named my username is devops to add some git configurations for it

         $ sudo su - devops -c "git config --global user.name 'devops'"
         $ sudo su - devops -c "git config --global user.email 'devops@gmail.com'"

Step-5: Installing a Java 11, First we need to search the java packages in yum package, if there you see any development environment package then choose it and install it and finally change the owner as devops in opt folder

         $ sudo yum search java
         $ sudo yum install java-11-amazon-corretto.x86_64 -y
         $ sudo chown -R devops:devops /opt
Step-6: 
1. Installing a Maven build tool, first of all change the directory to opt folder because to install some custom packages opt folder is good fit for us, search the latest version of maven in google and apply wget command  to install the  maven tar package      
         
         $ wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
2. for extrat the maven tar file we use the tar -xzvf command as follows:

         $ tar -xzvf apache-maven-3.9.6-bin.tar.gz
3. then rename the extracted tar file to maven and remove the tar.gz file:

         $ mv apache-maven-3.9.6 maven
         $ rm -rf apache-maven-3.9.6-bin.tar.gz

Step-7: Copy the soft link of /opt/maven/bin/mvn to /usr/local/bin/mvn in the devops user

         $ sudo su - devops -c "ln -s /opt/maven/bin/mvn /usr/local/bin/mvn"

Step-8: Installing the tomcat app server,first of all change the directory to opt folder because to install some custom packages opt folder is good fit for us, search the latest version of maven in google and apply wget command  to install the  tomcat tar package, then tar the extract file, remove the tar.gz file and rename the extracted file to tcserver

         $ wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz
         $ tar -xzvf apache-tomcat-9.0.85.tar.gz
         $ rm -rf apache-tomcat-9.0.85.tar.gz
         $ mv apache-tomcat-9.0.85 tcserver
Step-9: Then Configure the tomcat server to tomcat as a service, here we can write some script for the tomcat as a service config in the /etc/systemd/system/tomcat.service directory.

         $ echo  ' After=syslog.target network.target

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

Step-10: reload the daemon process service,then start and enable the tomcat as a service. 

      $ systemctl daemon-reload
      $ systemctl start tomcat
      $ systemctl enable tomcat

Step-11: Installing a Nginx web and proxy server, choose the development environment package from the list,then start and enable the nginx web server

      $ sudo yum search nginx
      $ sudo yum install nginx.x86_64 -y
      $ systemctl enable nginx
      $ systemctl start nginx

Step-12: Installing a mariadb database, choose the development environment package form the list,then start and enable the mariadb

      $ sudo yum install mariadb105-server.x86_64 -y
      $ sudo systemctl start mariadb
      $ sudo systemctl enable mariadb

Step-13: Clone the Studet-app repository

      $ git clone https://gitlab.com/rns-app/student-app.git

Run the script to setup the tools:
Login as root user and run the script:

         $ sudo su -
         $ ./install_student_app_tools.sh

Script-2:
Second script helps to setup the student app deployment it is in specific manner as follows:

Task-2: Login as devops user in MobaXTerm to delpoy the student app

Step-1: Create the file setup_studentapp.sh to delpoy the student app through devops user.

         $ #! /bin/bash

Step-2: change directory to opt and copy the /opt/student-app/dbscript/studentapp.sql directory to mysql -uroot      
         
         $ cd /opt/
         $ mysql -uroot < /opt/student-app/dbscript/studentapp.sql

Step-3: Manager's App Context XML

         $ cp /opt/student-app/tomcat/manager/context.xml /opt/tcserver/webapps/manager/META-INF

Step-4: Add User to Tomcat

         $ cp /opt/student-app/tomcat/conf/tomcat-users.xml /opt/tcserver/conf/

Step-5: Load DB Driver

         $ cp /opt/student-app/tomcat/lib/mysql-connector.jar /opt/tcserver/lib/

Step-6: Integrate Tomcat with DB

         $ cp /opt/student-app/tomcat/conf/context.xml /opt/tcserver/conf/

Step-7: Restart the Tomcat SErvice

         $ sudo systemctl stop tomcat
         $ sudo systemctl start tomcat

Step-8: Deploying Student App

         $ sudo yum install java-1.8.0-openjdk-devel.x86_64 -y

Step-9: change directory to  /opt/student-app/ and git pull to updated repository
         $ cd /opt/student-app/
         $ git pull origin master

Step-10: change the java version to run the maven command for build purpose and run the package command.
         
         $ echo 2 | sudo alternatives --config java
         $ mvn clean package

Step-11: change the java version again to deploy the student.war file
         
         $ echo '1' | sudo alternatives --config java
Step-12: Copy the /opt/student-app/target/*.war to /opt/tcserver/webapps/student.war
         
         $ cp /opt/student-app/target/*.war /opt/tcserver/webapps/student.war

Step-13: Nginx static app deployment, change directory to nginx deployment directory, remove the all file in it, change directory to opt and clone the static-project webiste through git command, copy all files in static-project/iPortfolio/ to nginx delopyment directory.

         $ cd /usr/share/nginx/html/
         $ sudo rm -rf *
         $ cd /opt/
         $ git clone https://gitlab.com/rns-app/static-project.git
         $ cd static-project/iPortfolio/
         $ sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html/

Step-14: Reverse Proxy Configuration

         $ sudo cp /opt/student-app/nginx/nginx.conf /etc/nginx/
         $ sudo systemctl stop nginx
         $ sudo systemctl start nginx
