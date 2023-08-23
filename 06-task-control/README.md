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
