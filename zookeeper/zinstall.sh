#!/bin/bash
#######################################################################
#  Zookeeper install shell script 
#    Instead of installing the default zookeeper with apt install
#    this script pulls the tar from apache mirrors and installs
#
#    You will need to run this with sudo privleges or as root
#    Before running, make sure edit the zoo.cfg AND zookeeper.service 
#    file for your situation
#     
#######################################################################
# General script settings

# My current install version is 3.6.2, but change if you want a different one
ZK_VERS=3.6.2

# your probably running this on the host to install on
ZK_HOSTNAME=$(hostname)
# or you can override, comment above and edit below
#ZK_HOSTNAME=<your desired hostname>


######################################################################
# Get the zookeeper bin install files from apache
# I used the Ontario mirror but change for local location if desired
wget https://mirror.csclub.uwaterloo.ca/apache/zookeeper/zookeeper-${ZK_VERS}/apache-zookeeper-${ZK_VERS}-bin.tar.gz
tar -xvf apache-zookeeper-${ZK_VERS}-bin.tar.gz
rm apache-zookeeper-${ZK_VERS}-bin.tar.gz

# make a zookeeper user and give it a password
useradd zookeeper
ZPASS=$(tr -dc A-Za-z0-0 </dev/urandom | head -c 16 ; echo '')
echo $ZPASS > zookpasswd.txt
echo zookeeper:$ZPASS | chpasswd

# make zookeeper folders
mkdir /usr/local/zookeeper
mkdir /var/zookeeper
mkdir /var/zookeeper/logs

# move the downloaded files to its app folder
cp -R apache-zookeeper-${ZK_VERS}-bin/* /usr/local/zookeeper
cp zoo.cfg /usr/local/zookeeper/conf/zoo.cfg

# you can comment out this line and customize your zoo.cfg
sed -i "s/<<host name>>/${ZK_HOSTNAME}/g" /usr/local/zookeeper/conf/zoo.cfg

chown -R zookeeper:zookeeper /usr/local/zookeeper
chown zookeeper:zookeeper /var/zookeeper
chown zookeeper:zookeeper /var/zookeeper/logs

# now the copy the systemd service file
cp zookeeper.service /etc/systemd/system

##### Final cleanup
rm -r apache-zookeeper-${ZK_VERS}-bin

