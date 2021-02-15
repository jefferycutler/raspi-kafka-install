#!/bin/bash

ZK_VERS=3.6.2

rm -rf apache-zookeeper-${ZK_VERS}-bin
rm -rf /usr/local/zookeeper
rm -rf /var/zookeeper
rm -rf /var/zookeeper/logs
rm -rf /etc/systemd/system/zookeeper.service

userdel -r zookeeper

