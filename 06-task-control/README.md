# Task Control
## loop
Some modules accept lists, however some don't. A list can be processed using the loop keyword
* loop is at the module level, and name should have "{{ item }}" as keyword so the loop takes place
```yaml
---
- name: loop demonstration
  hosts: node1
  tasks:
  - name: use a loop with service package
    service:
      name: "{{ item }}" 
      state: started
    loop:
      - httpd
      - firewalld
```
## loop with variables
```yaml
---
- name: loop demonstration
  hosts: node1
  vars:
    services:
      - vsftpd
      - httpd
  tasks:
  - name: use a loop with service package
    service:
      name: "{{ item }}" 
      state: started
    loop:
      "{{ services }}"
```
## loop with multivalue vars from vars file:
** vars file must be in list format and not dict **
```yaml
users:
  - username: arthur
    homedir: /home/arthur
    shell: /bin/bash
    groups: wheel
  - username: morgana
    homedir: /home/morgana
    shell: /bin/bash
    groups: users
```
* with the corresponding playbook
```yaml
---
- name: example playbook using vars files list into loop
  hosts: localhost
  vars_files: vars/multivalue.yaml
  tasks:
  - name: output vals to check the correct feeding of vars into loop
    debug:
      msg: "Reading username from vars: {{ item.username }}\nReading homedir from vars: {{ item.homedir }}"
    loop:
      "{{ users }}"
```
