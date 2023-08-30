# RHCE-EX294
The purpose of this repository is to provide both a lab environment and a recap for the RHCE and ex294 exam v9.
Similar repositories exist, however I wanted one fully compatible with libvirtd, as opposed to Oracle VirtualBox, which comes with Fedora.


## Installation and config for libvirt and fedora to run vagrant
Follow the instructions [here](https://vagrant-libvirt.github.io/vagrant-libvirt/)

additionally run the following commands:
```bash
# so you don't have to type sudo each time for a QEMU system session
$ sudo usermod -aG libvert $USER
# sets libvirt as default vagrant provider
$ echo "export VAGRANT_DEFAULT_PROVIDER=libvirt" >> ~/.bashrc 
```

## Lab Environment
The lab environment consists of repository node, a control node and 4 slave nodes. Control node and slave nodes will install software from the repository node.
| hostname | ip address | additional disks |
| -------- | ---------  | ---------------- |
| repository | 10.0.0.10 | NO |
| control | 10.0.0.100 | NO |
| node1 | 10.0.0.101 | 400M + 5G |
| node2 | 10.0.0.102 | 400M + 5G |
| node3 | 10.0.0.103 | NO |
| node4 | 10.0.0.104 | NO |


## Provisioning
Make sure that the following env variables are populated:
* RH_SUBSCRIPTION_MANAGER_USER = your redhat user
* RH_SUBSCRIPTION_MANAGER_PW = your redhat account password
* RHEL_ISO_PATH = the full path for thr redhat iso file 
* get used to populate the .vimrc file so you can edit playbook files easily


Simply run `$ vagrant up`

## Resetting the lab
Run `$ reset_lab.sh`

# Course
[01-installation](01-installation/README.MD)
