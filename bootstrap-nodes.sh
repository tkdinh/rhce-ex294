#!/bin/bash
echo $HOSTNAME > host.txt
# remove configured repositories
sudo rm  /etc/yum.repos.d/*
# allow password authentication via ssh
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;