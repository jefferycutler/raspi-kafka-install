# Rasperry Pi Kafka Install Repo

There are a lot of pages on the internet that talk about installing Kafka on a Raspberry Pi.  Each one was missing one peice or another, no single page or setup instructions had what I needed;

* Install Zookeeper and Kafka
* Set them up as a service in systemd
* include security setup for SSL and server and client
* have an install setup in Ansible

I've tested this setup on a Raspberry Pi 3 model B Rev 1.2.  I used Zookeeper vers 3.6.2 and Kafka 2.7 with Scala 2.13.  You can tinker and edit this as needed for your purposes.  I have not setup a process to install any dependencies needed, put that on the to do list.  You will need to insure that Java 8 is installed, I used OpenJDK.  I believe Java 11 also works with Kafka but haven't tried it.

## Project Folders

### \zookeeper
Raspbian, Debian, and Ubuntu all have a zookeeper you can install with an apt command.  I just don't like how they have set it up and decided to "roll my own" install with the scripts in this folder.  The zinstall.sh script should be as root. Definately review and edit it for your needs as needed.  This will download Zookeeper, unpack and install it in /usr/local/zookeeper folder.  A zookeeper user will be created with a random generated password.  There is a custom zoo.cfg file that will be copied over the default one downloaded in the tar package.  The following folders are created for zookeeper;

* /usr/local/zookeeper - the zookeeper program files
* /var/zookeeper - the data directory
* /var/zookeeper/logs - for log files

A zookeeper service will be setup in systemd but not enabled.  You will need to do this to allow start up at boot.

### \kafka
Contains the files for installing Kafka as a service.  The kinstall.sh will download Kafka and install it on the device you run it on.  This assumes you have a running zookeeper service all ready.  You need to run this with escalated priveleges (sudo/root).  There is a custom server.properties file and kafka-server-start.sh.  The server properties can be tailored to what you need.  This will be copied to the kafka program folder.  The kafka-server-start.sh replaces the one that comes with Kafka, there are some additional settings that had to be changed (according to several web sites I saw) to make this work on Raspberry Pi.

A kakfa user is created with random password.  The following folders are created for Kafka;
* /usr/local/kafka - the kafka program files
* /var/kafka - the data folder
* /var/log/kafka - for system log files produced by kafka

### \ssl
If you want to enable SSL for servers and clients this folder contains a script to generate and self sign ssl certificates and keystores.  One set is for the Kafka server and the other the client if ACL is setup with SSL keys.


There is more work to be done when I can get to it.

