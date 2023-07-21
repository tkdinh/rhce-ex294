# rhce-ex294
repo for rhce and ex294 exam

# installation and config for libvirt and fedora to run vagrant
https://vagrant-libvirt.github.io/vagrant-libvirt/

sudo usermod -aG libvert $USER
echo "export VAGRANT_DEFAULT_PROVIDER=libvirt" >> ~/.bashrc 


# TO DO
check storages
create local repo on repo 
https://www.redhat.com/sysadmin/apache-yum-dnf-repo
https://access.redhat.com/solutions/23016
or a copy of remote repo
montar localmente ou nao
sudo dnf install -y yum-utils # so we can get reposync
user comando reposync

criar o local.repo com multiline echo
