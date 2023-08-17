#!/bin/bash
ansible node1 -m dnf -a "name=httpd state=present"
ansible node1 -m service -a "name=httpd state=started enabled=yes"
ansible node1 -m user -a "name=anna state=present"
ansible node1 -m copy -a "src=/etc/hosts dest=/tmp/hosts"


