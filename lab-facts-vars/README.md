# Lab 6
## Lab 6-1
Configure a playbook that works with custom facts and meets the following requirements:
* use lab6 project directory
* create inventory file where node3 is member of the host group named **file** and node4 is member of host group named **lamp**
* Create custom packages facts file 
```ini
[packages]
  smb_package = samba
  ftp_package = vsftpd
  db_package = mariadb-server
  web_package = httpd
  firewall_package = firewalld
```
* create custom services facts file
```ini
[services]
  smb_service = smb
  ftp_service = vsftpd
  db_service = mariadb
  web_service = httpd
  firewall_service = firewalld
```
* Create a playbook with name lab61.yaml that copies these facts to managed hosts.
* use a remote-dir variable to specify where facts should be copied into
* run playbook and validate that all is as expected

## Lab 6-2
Create a playbook that implements the following requirements
* use a variable inclusion file with name allvars.yaml
** web_root = /var/www/html
** ftp_root = /var/ftp
* create a playbook that sets up the file and webservices.
* firewall must also be configured accordingly
* webservice must provide access to index.html containing the text "Welcome to the Ansible Web Server"
* run the playbook and test either with playbook or ad-hoc commands´

