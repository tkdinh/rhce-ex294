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

### multivalue variables

#### vars file array_example - array example using dict notation
```code
users:
  linda:
    username: linda
    homedir: /home/linda
    shell: /bin/bash
  zabbix:
    username: zabbix
    homedir: /var/lib/zabbix
    shell: /sbin/nologin
```
then, the vars can be used as such
```yaml
---
- name: example usage of playbook with vars file using arrays
  hosts: all
  vars_files:
  - vars/array_example 
  tasks:
  - name: list vars values
    debug:
      msg: "user {{ users.zabbix.username }} has home set to {{ users.zabbix.homedir }} and shell set to {{ users.zabbix.shell }}"
```
### magic variables
| variable | usage |
| -------- | ----- |
| hostvars | all hosts in inventory and assigned variables |
| groups | all groups in inventory |
| group_names | all groups current host is a member of |
| inventory_hostname | inventory hostname for current host |
* can be used with
`$ ansible localhost -m debug -a 'var=hostvars["node1"]'`

## Variable Precedence
* always from most specific to most generic
command > playbook > vars file

# Vault
* man ansible-vault
| sub-command | description |
| ----------- | ----------- |
| create         | Create new vault encrypted file |
| decrypt        | Decrypt vault encrypted file    |
| edit           | Edit vault encrypted file       |
| view           | View vault encrypted file       |
| encrypt        | Encrypt YAML file               |
| encrypt_string | Encrypt a string                |
| rekey          | Re-key a vault encrypted file   |

* positional arguments:
  * --ask-vault-password
  * --vault-password-file **don't forget to chmod 600 the password file**

* sample command for running a playbook which references a vars file with encrypted content 
`$ ansible-playbook -i inventory <playbook> --vault-password-file <path-to-password-file>`

## example vault encrypted file
```
$ANSIBLE_VAULT;1.1;AES256
34346266646333373732306630626430653065303839633766626466363164323265646231633131
3930313363383863633166393031363764336134303137330a336365346664613036383734633834
34366566653632363630613266373766343366636234646237613365663338323135333261396631
6534616165326235390a616136383531353033303132643662316536643037626338343465326236
61663562656436386666653466616262343363346663656637653738313664343466376538373065
3364386661646635383331336533393031336137643330386332
```
## example usage with playbook and commnd
```yaml
---
- name: Example usage of a playbook using secrets
  hosts: all
  vars_files: vars/secrets.yaml
  tasks:
  - name: display the secrets 
    debug:
      msg: "this is the string for {{ username }} this is the string for {{ password }}"
```
* command usage
`$ ansible-playbook playbook-using-secrets.yaml --limit node1 --ask-vault-password`
```
* can be automated using a vault password file

# Capturing command output with **register**
* vars used for capturing contents don't use {{ }}
```yaml
---
- name: Capture command output with register
  hosts: node1
  tasks:
  - name: first example of capturing values
    shell: cat /etc/passwd
    register: file_contents
  - name: output the captured values
    debug:
      var: "file_contents"
```
* additional keys which can be used with register

| key | usage |
| --- | ----- |
| cmd | command used |
| rc | return of command code. 0 if successful |
| stderr | error messages |
| stderr_lines | same but line by line |
| stdout | command output |
| stdout_lines | same but line by line |


