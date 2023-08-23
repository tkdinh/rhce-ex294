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
### combining register and when
```yaml
---
- name: combining when and register
  hosts: localhost
  tasks:
  - name: register contents of command
    shell: cat /etc/passwd
    register: contents
  - name: output msg if expected content is not found
    debug:
      msg: "user morgan was not found!"
    when:
      contents.stdout.find("morgan") == -1
```
### controlling flow with ignore_errors and using conditionals
```yaml
---
- name: using ignore errors just to capture some output
  hosts: localhost
  tasks:
  - name: get httpd service status
    command:
      systemctl is-active httpd
    ignore_errors:
      yes
    register: result
  - name: output error msg
    debug:
      var: result # better to use this
      #msg: "this is the returned content: {{ result }}"
  - name: activate service if httpd is not running
    service:
      name: httpd
      state: started
      enabled: true
    when:
      result.rc == 1
```
## Handlers
Handlers are used to trigger an action if a change takes place.
* for instance, let's suppose you change httpd config, and you which to restart the service. handlers allow this, but only if a change is made, avoiding a restart if the change is not made.
* keywords
** notify
** handlers
```yaml
---
- name: example usage of handlers
  hosts: node3
  vars:
    webserver:
      - httpd
  tasks:
  - name: change landing page
    copy:
      contents: "Hello World"
      dest: /var/www/html/index.html
    notify:
      restart_httpd
  handlers:
  - name: restart_httpd
    service:
      name: httpd
      state: restarted
```
### forcing handler execution even if nothing changes
at the play leve set
* force_handlers: true

## failing a task
```yaml
---
- name: using failed_when
  hosts: localhost
  tasks:
  - name: run some script
    command: echo hello world
    ignore_errors: yes
    register: contents
    failed_when: '"world" in contents.sdout'
  - name: we failed the task so we shouldn t see this
    debug:
      msg: "Hi there"
## changed_when is used to force a task changed something 
```yaml
--- 
- name: using changed_when
  hosts: localhost
  tasks:
  - name: check local time
    command: date
    register: result
    changed_when: false
  - name: print time
    debug:
      var: result.stdout
```
