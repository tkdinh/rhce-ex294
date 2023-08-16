# ad-hoc commands
## usage
* quick tests to validate something
* quick discovery tasks to validate if criteria are met
* one-time quick tasks
## syntax
```bash
$ ansible <hosts> -m <module> -a "<args>"
# add user to all hosts
ansible all -m user -a "name=jfgsilva"
# remove user from all hosts
ansible all -m user -a "name=jfgsilva state=absent"
```
* to run an arbitrary command
ansible all -m command -a "id jfgsilva"

## important modules
| module | usage |
| ------ | ----- |
| command | runs commands with no shell: pipes and redirect do not work |
| shell | like command but uses shell |
| raw | run commands on top of SSH without using python |
| copy | copies files | 
| dnf | manages packages |
| service | manages systemd |
| ping | validates if hosts can be reached and managed |

### examples
* installing tmux
`$ ansible all -m dnf -a "name=tmux state=present"`

* ensuring firewalld is running and enabled
`$ ansible all -m service -a "name=firewalld state=started enabled=yes"

* using raw to bootstrap managed node
`$ ansible -u vagrant -i inventory node2 --ask-pass -m raw -a "dnf install python3 -y" -b`

* populating a file with content using copy module
`$ ansible -i inventory node3 -m copy -a 'content="Hello World" dest=/home/vagrant/hi'`

### additional information
* checking all documentation and a specific module
`ansible-doc -l`
`ansible-doc user` 
* a local copy of the documentation is available under https://docs.ansible.com/
* using ansible navigator to browse documentation:
`$ ansible-navigator doc user`

* **important** to get specific info for usage in a playbook use
`ansible-doc -s <module name>` which can be used in tandem with vim's :r !ansible-doc -s module-name
