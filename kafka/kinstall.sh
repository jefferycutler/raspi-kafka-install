#!/bin/bash
#######################################################################
#  Kafka install shell script 
#
#    You will need to run this with sudo privleges or as root
#    Before running, make sure to edit the server.properties 
#    file for your situation
#     
#######################################################################
# General script settings

# My current install version is 3.6.2, but change if you want a different one
KF_VERS=2.7.0
KF_SCVERS=2.13

# your probably running this on the host to install on
KF_HOSTNAME=$(hostname)
# or you can override, comment above and edit below
#KF_HOSTNAME=<your desired hostname>

######################################################################
# Get the zookeeper bin install files from apache
# I used the Ontario mirror but change for local location if desired
wget https://mirror.csclub.uwaterloo.ca/apache/kafka/${KF_VERS}/kafka_${KF_SCVERS}-${KF_VERS}.tgz 
tar -xvf kafka_${KF_SCVERS}-${KF_VERS}.tgz
rm kafka_${KF_SCVERS}-${KF_VERS}.tgz

# make a zookeeper user and give it a password
useradd kafka
KPASS=$(tr -dc A-Za-z0-0 </dev/urandom | head -c 16 ; echo '')
echo $KPASS > kafkapasswd.txt
echo kafka:$KPASS | chpasswd

# make kafka folders
mkdir /usr/local/kafka
mkdir /var/kafka
mkdir /var/log/kafka

# move the downloaded files to its app folder
cp -R kafka_${KF_SCVERS}-${KF_VERS}/* /usr/local/kafka
cp -f server.properties /usr/local/kafka/config/server.properties
cp -f kafka-server-start.sh /usr/local/kafka/bin/

# you can comment out this line and customize your server.properties
sed -i "s/<<host name>>/${KF_HOSTNAME}/g" /usr/local/kafka/config/server.properties

chown -R kafka:kafka /usr/local/kafka
chown kafka:kafka /var/kafka
chown kafka:kafka /var/log/kafka

# now the copy the systemd service file
cp kafka.service /etc/systemd/system

##### Final cleanup
rm -r kafka_${KF_SCVERS}-${KF_VERS}
