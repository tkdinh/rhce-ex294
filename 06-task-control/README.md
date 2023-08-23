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
### loop with variables
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
### loop with multivalue vars from vars file:
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
## When: running tasks conditionally
**When** is the keyword to run tasks conditionally and it's added at the module level - same as loop
```yaml
---
- name: using conditionals as example
  hosts: localhost
  tasks:
  - name: install apache on redhat
    dnf: 
      name: httpd
      state: present
    when: ansible_facts['os_family'] == "RedHat"
  - name: installe apache on debian
    apt:
      name: apache2
      state: present
    when: ansible_facts['os_family'] == "Debian"
```
### conditional tests

| test | syntax |
| ---- | ------ |
| var exists | var is defined |
| var doesn't exist | var is not defined |
| var is true | var or var is true |
| var is false | not var or var is not true |
| equality if number | key == val |
| equality if string | key == " val |
| likewise for gt gte lt lte | > >= < <= |

```yaml
---
- name: testing conditionals and ansible facts example usage
  hosts: localhost
  tasks:
  - name: testing existence of /dev/sda
    debug:
      msg: a disk device /dev/sda exists
    when:
      ansible_facts['devices']['sda'] is defined
  - name: disk /dev/sdc shouldn't exist
    debug:
      msg: dev/sdc does not exist
    when:
      ansible_facts['devices']['sdc'] is not defined
```
### testing variable presence in list of variables
```yaml
---
- name: test if var is in vars
  hosts: localhost
  vars:
    supported_packages:
      - httpd
      - sqlserver
    database:
      - mariadb
      
  tasks:
  - name: actual failing test
    debug:
      msg: " maria db is not in supported packages"
    when:
      database not in supported_packages
  - name: skipping the failed test
    debug:
      msg: " maria db is not in supported packages"
    when:
      database in supported_packages
```
### more complex testing
```yaml
---
- name: complex testing
  hosts: localhost
  vars:
    my_var: Hello
  tasks:
  - name: execute kernel update if enough space is available also using loop 
    package:
      name: kernel
      state: latest
    loop: "{{ ansible_facts['mounts'] }}"
    when: item.mount == "/boot" and item.size_available > 200000000
```

