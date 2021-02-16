#!/bin/bash

KF_VERS=2.7.0
KF_SCVERS=2.13

rm -rf kafka_${KF_SCVERS}-${KF_VERS}
rm -rf /usr/local/kafka
rm -rf /var/kafka
rm -rf /etc/systemd/system/kafka.service

userdel -r kafka

