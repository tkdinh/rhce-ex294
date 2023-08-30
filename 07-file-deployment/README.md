# File Deployment
## Modules
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

