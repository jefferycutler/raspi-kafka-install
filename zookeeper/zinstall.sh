#!/bin/bash
#######################################################################
#  Zookeeper install shell script 
#    Instead of installing the default zookeeper with apt install
#    this script pulls the tar from apache mirrors and installs
#    I just don't like how the apt version installs
#
#    You will need to run this with sudo privleges or as root
#######################################################################

# First the settings for this script
ZK_VERS=3.6.2

# Get the zookeeper install version 
wget https://mirror.csclub.uwaterloo.ca/apache/zookeeper/zookeeper-${ZK_VERS}/apache-zookeeper-${ZK_VERS}-bin.tar.gz
tar -xvf apache-zookeeper-${ZK_VERS}-bin.tar.gz
rm apache-zookeeper-${ZK_VERS}-bin.tar.gz

# make a zookeeper user
useradd zookeeper
ZPASS=$(tr -dc A-Za-z0-0 </dev/urandom | head -c 16 ; echo '')
echo $ZPASS > zookpasswd.txt
echo zookeeper:$ZPASS | chpasswd

# make zookeeper folders
#mkdir /usr/local/zookeeper
#mkdir /var/zookeeper
#mkdir /var/zookeeper/logs

# move the downloaded files to its app folder
cp -R apache-zookeeper-${ZK_VERS}-bin/* /usr/local/zookeeper
cp zoo.cfg /usr/local/zookeeper/conf/zoo.cfg

chown -R zookeeper:zookeeper /usr/local/zookeeper
chown zookeeper:zookeeper /var/zookeeper
chown zookeeper:zookeeper /var/zookeeper/logs





##### Final cleanup
rm -r apache-zookeeper-${ZK_VERS}-bin

