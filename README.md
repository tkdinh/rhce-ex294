# rhce-ex294
repo for rhce and ex294 exam

# installation and config for libvirt and fedora to run vagrant
https://vagrant-libvirt.github.io/vagrant-libvirt/

sudo usermod -aG libvert $USER
echo "export VAGRANT_DEFAULT_PROVIDER=libvirt" >> ~/.bashrc 


# TO DO
set up control with ansible
create playbooks to set up the env for repo
create playbook to set up the env for nodes
check storages