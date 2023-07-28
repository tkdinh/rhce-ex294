# Configuration guide

## PROJECTS
* create a dir specific for each project that uses same hosts and playbooks
* this dir should have an inventory and ansible.cfg file present on the directory root

### ansible.cfg
* manages the project configuration

````bash
# generate ansible.cfg from template
$ ansible-config init --disabled > ansible.cfg
```
* important fields
|key|value|
|private_key_file|<path-to-ssh-key>|
|become|True|
|remote_user|automation|
|host_key_checking|False|
|become_user|root|
|become_method|sudo|


##
