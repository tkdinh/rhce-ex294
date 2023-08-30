# File Deployment
## Modules stat and file
Several modules can be used to depoly file, depending on the objectives.
| module | Usage |
| ------ | ----- |
| copy | copy to remote host |
| fetch | gets files from remote host |
| file | manages files and properties |
| find | finds files based on properties |
| lineinfile | manages lines in textfiles |
| blockinfile | manages blocks of text in files |
| replace | replaces strings in files based on regex |
| synchronize | rsync based tasks |
| stat | gets stats on file | 

### stat - manage file attributes
stat modules gets files status and is mainly used to get infofrom the file and is used in tandem with the register and when keywords in ansible

```yaml
---
- name: playbook demonstrating stat usage
  hosts: localhost
  tasks:
  - name: using stat
    stat:
      path: /etc/hosts
    register: content
  - name: diplaying contents 
    debug:
      msg: "{{ content.stat }}"
    when:
      content.stat.exists
```
you can also fail controlling the flow
```yaml
---
- name: playbook demonstrating stat usage and controling the flow
  hosts: localhost
  tasks:
  - name: create a file
    command:
      touch /tmp/myfile
  - name: using stat
    stat:
      path: /tmp/myfile
    register: content
  - name: diplaying contents 
    debug:
      msg: "{{ content.stat }}"
  - fail:
      msg: "user and/or permissions are incorrect. owner is {{ content.stat.pw_name }} and permissions are {{ content.stat.mode }}"
    when:
      content.stat.pw_name != "root" and content.stat.mode != "0600"
```

### file
file module is used to change file attributes, works great with stat module to conditionally change something
```yaml
---
- name: playbook demonstrating stat and file module
  hosts: localhost
  become: true
  tasks:
  - name: create a file
    command:
      touch /tmp/myfile
  - name: using stat
    stat:
      path: /tmp/myfile
    register: content
  - name: diplaying contents 
    debug:
      msg: "{{ content.stat }}"
  - file:
      path: /tmp/myfile
      group: jfcgsilva
      mode: '0600'
      owner: root 
    when:
      content.stat.pw_name != "root" and content.stat.mode != "0600"
```
## File contents
### lineinfile
using regex to change a line in some file
```yaml
---
- name: lineinfile usage example
  hosts: localhost
  tasks:
  - name: change resolv.conf
    lineinfile:
      path: /etc/resolv.conf
      regexp: '^nameserver'
      line: 'nameserver 8.8.8.8'
    notify: restart_network
  - name: configure sshd
    lineinfile:
      path: /etc/ssh/sshd_config
      regexp: '^PermitRootLogin'
      line: 'PermitRootLogin no'
    notify:
      restart_sshd

  handlers:
  - name: restart_sshd
    service:
      name: sshd
      state: restarted
  - name: restart_network
    service:
      name: NetWorkManager
      state: restarted
```
