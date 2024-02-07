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

Task-1: update the system and enable security:

         $ sudo yum update -y
         $ sudo systemctl stop firewalld
         $ sudo setsebool httpd_can_network_connect 1
      
Task-2: Create devops user and enable password based authentication:
      
         $ echo "devops" | passwd --stdin devops
         $ echo 'devops    ALL=(ALL)     NOPASSWD: ALL' | sudo tee -a /etc/sudoers
         $ sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
         $ service sshd restart

Task-3: We have to download some common tools for the configuration purpose:

         $ sudo yum install tree wget zip unzip gzip vim net-tools git bind-utils python3-pip jq -y

Task-4: Configure some userlevel configuration I named my username is devops to add some git configurations for it

         $ sudo su - devops -c "git config --global user.name 'devops'"
         $ sudo su - devops -c "git config --global user.email 'devops@gmail.com'"

Task-5: Installing a Java 11, First we need to search the java packages in yum package, if there you see any development environment package then choose it and install it and finally change the owner as devops in opt folder

         $ sudo yum search java
         $ sudo yum install java-11-amazon-corretto.x86_64 -y
         $ sudo chown -R devops:devops /opt
Task-6: 
1. Installing a Maven, first of all change the directory to opt folder because to install some custom packages opt folder is good fit for us, search the latest version of maven in google and apply wget command  to install the  maven tar package      
         
         $ wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
2. for extrat the maven tar file we use the tar -xzvf command as follows:

         $ tar -xzvf apache-maven-3.9.6-bin.tar.gz
3. then rename the extracted tar file to maven and remove the tar.gz file:

         $ mv apache-maven-3.9.6 maven
         $ rm -rf apache-maven-3.9.6-bin.tar.gz

Task-7: 




Run the script to setup the tools:
Login as root user and run the script:

         $ sudo su -
         $ ./scriptname.sh

Second script helps to complete following tasks:

Task-1:
Task-2: 

       
