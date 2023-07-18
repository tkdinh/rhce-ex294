#!/bin/bash

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y; sudo dnf install -y sshpass python3-pip python3-devel httpd sshpass vsftpd createrepo
python3 -m pip install -U pip ; python3 -m pip install pexpect; python3 -m pip install ansible

#sudo localectl set-keymap pt