#!/bin/bash
# allow password authentication via ssh
# sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd;
echo 'PermitRootLogin yes' | sudo tee /etc/ssh/sshd_config.d/01-permitrootlogin.conf
sudo systemctl restart sshd
