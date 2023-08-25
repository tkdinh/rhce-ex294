#!/bin/bash

# create the inventory
ansible-config init --disabled > ansible.cfg
# change for remote_user, private_key_file, inventory

# create inventory
echo "node4" > inventory

# generate facts list so we can navigate the vars better
ansible node4 -m setup > facts.json

# create vars and vars_file
mkdir vars
echo "packages:\n  - httpd\n  - mod_ssl" > vars/packages.yaml
