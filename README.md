# demo
This is demo to show git activities / Commands
I have cloned repo to win.

This 2-tier automation shell script helps to install App environment:
   1. Maven Build Tool
   2. Tomcat App Server
   3. Nginx Web Server
   4. Maria DB Server
   5. Git

Total 3 scripts haveen implemented to complete 3 tier App deployment

First script helps to complete following tasks:

Task-1: update the system and enable security:

         $ sudo yum update -y
         $ sudo systemctl stop firewalld
         $ sudo setsebool httpd_can_network_connect 1
      
Task-2: Create devops user and enable password based authentication:
      
         $ echo "devops" | passwd --stdin devops
         $ echo 'devops    ALL=(ALL)     NOPASSWD: ALL' | sudo tee -a /etc/sudoers
         $ sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
         $ service sshd restart

Task-3: 

Run the script to setup the tools:
Login as root user and run the script:

         $ sudo su -
         $ ./scriptname.sh

Second script helps to complete following tasks:

Task-1:
Task-2: 

       
