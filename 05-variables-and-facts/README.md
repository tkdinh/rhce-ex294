# Variables and Facts

## facts
**ansible_facts**
```yaml
---
- name: display all facts
  hosts: node3
  tasks:
  - name: return all facts
    debug:
      var: ansible_facts
  - name: return dotted notation example
    debug:
        var: ansible_facts.default_ipv4.address
```
* using debug keyword you can see the value of a certain variable
* to access values inside multi-value variables you can use python dict notation or dotted notation

### common facts for ex294
| variable | usage |
| -------- | ----- |
| ansible_facts.hostname | hostname |
| ansible_facts.distribution |  |
| ansible_facts.default_ipv4.address | main ivp4 address |
| ansible_facts.interfaces | list of intefraces |
| ansible_facts.devices | list of attached storage devices |
| ansible_facts.devices.sda.partitions.sda1.size | size of sda1 partition  |
| ansible_facts.distribution_version | version |
| ansible_facts['distribution_version'] | version |
* ansible-doc -l | grep fact

### disabling fact gathering
* at the play level add gather_facts: no

### enabling fact cache
`$ sudo dnf install redis -y; systemctl --now enable redis`

on ansible.cfg add:
```ini
[defaults] 
gathering = smart
fact_caching = redis
fact_caching_timeout = 86400
```
### custom facts
* stored under /etc/ansible/facts.d/* on **remote_host**
* files must end in .fact extension
* either INI or JSON format

```ini
[packages]
web_package = httpd
ftp_package = vsftpd

[services]
web_service = httpd
ftp_service = vsftpd
```

#### exporting facts
```yaml
---
- name: exporting facts to remote host
  host: node3
  vars:
    remote_dir: /etc/ansible/facts.d
    facts_file: node3_custom_facts.fact
  tasks:
  - name: Create remote dir
    file:
      state: directory
      recurse: yes
      path: "{{ remote_dir }}"
  - name: Copy the facts file to remote host
    copy:
      src: "{{ facts_file }}"
      dest: "{{ remote_dir }}"
```

#### using exported facts on playbooks
* validate full fact expansion with `$ ansible node3 -m setup -a 'filter=ansible_local'`
```yaml
---
- name: using exported facts
  hosts: node3
  tasks:
  - name: install httpd using a fact instead of var
    dnf:
      name: "{{ ansible_facts['ansible_local']['node3_custom_facts']['packages']['web_package'] }}"
      state: present
```

## Variables

### vars declaration
Variables are either declared on the play section of the playbook or in include files

### Vars in play section of playbooks
if a value starts with a variable double-quotes must be used
```yaml
---
- name: Create a user using a variable
  hosts: node3
  vars:
    users: gru
  tasks:
  - name: create user {{ users }} on host {{ ansible_hostname }}
    user:
      name: "{{ users }}"
``` 
### Vars in include file
* create a vars directory in current project
```code
my_package: nmap
my_ftp_service: vsftpd
my_file_service: smb
```
* reference the file in the playbook using vars_files: vars/<filename>
```yaml
---
- name: install some stuff using vars
  hosts: node3
  vars_files: vars/common
  tasks:
  - name: install packages
    dnf:
      name: "{{ my_package }}"
      state: present
```

### Variable types
| type | Usage |
| ---- | ----- |
| fact | system propertie |
| variable | user declared value |
| magic variable | system variable automatically set |


### vars in implicit include files
* group_vars
* host_vars
check [implicit include files](https://github.com/jfgsilva/rhce-ex294/tree/variables-facts/05-variables-and-facts/host-groups-vars)
