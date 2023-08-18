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
