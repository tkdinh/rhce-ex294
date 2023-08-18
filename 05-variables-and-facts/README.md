# Variables

## Vars in play section of playbooks
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
## Variable types
| type | Usage |
| ---- | ----- |
| fact | system propertie |
| variable | user declared value |
| magic variable | system variable automatically set |

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




