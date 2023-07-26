#!/bin/bash

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config; sudo systemctl restart sshd
#sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y; sudo dnf install -y sshpass python3-pip python3-devel httpd sshpass vsftpd yum-utils
#python3 -m pip install -U pip ; python3 -m pip install pexpect; python3 -m pip install ansible

#sudo localectl set-keymap pt

# create repo to be served by apache
sudo mkdir -p /local_repo/mnt /local_repo/automation

# permanently add the iso mount
sudo sed -i -e '$a/dev/sr0 /local_repo/mnt iso9660 ro 0 0\n' /etc/fstab
sudo mount -a



# configure the repo
echo -e "[BaseOS]\nname=BaseOS\ngpgcheck=0\nbaseurl=file:///local_repo/mnt/BaseOS\n\n[AppStream]\nname=AppStream\ngpgcheck=0\nbaseurl=file:///local_repo/mnt/AppStream" | sudo tee /etc/yum.repos.d/local.repo

# install utils
sudo dnf install -y yum-utils httpd

# enable automation repo
sudo subscription-manager repos --enable=ansible-automation-platform-2.4-for-rhel-9-x86_64-source-rpms

sudo reposync -p /local_repo/automation --download-metadata --repoid=ansible-automation-platform-2.4-for-rhel-9-x86_64-rpms

# configure apache
sudo systemctl --now enable httpd
sudo firewall-cmd --permanent --zone=public --add-service https
sudo firewall-cmd --permanent --zone=public --add-service http
sudo firewall-cmd --reload
sudo sed -i 's!DocumentRoot "/var/www/html"!DocumentRoot "/local_repo"!g' /etc/httpd/conf/httpd.conf
sudo sed -i 's!<Directory "/var/www/html">!<Directory "/local_repo">!g' /etc/httpd/conf/httpd.conf
sudo sed -i 's/Options Indexes FollowSymLinks/Options All Indexes FollowSymLinks/g' /etc/httpd/conf/httpd.conf



# create local copy of repo
# sudo reposync -p /local_repo --download-metadata --repoid=BaseOS
# sudo reposync -p /local_repo --download-metadata --repoid=AppStream



# remove test page
sudo rm -rf /etc/httpd/conf.d/welcome.conf


# configure selinux
sudo semanage fcontext -a -t httpd_sys_content_t "/local_repo(/.*)?"
sudo restorecon -R -v /local_repo

# restart httpd
sudo systemctl restart httpd
