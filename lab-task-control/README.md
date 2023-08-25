# Scenario
## write a playbook that meets the following requirements. You can use multiple plays
* Write a first play that installs httpd and mod_ssl packages on node4
* Use variable inclusion to define package names in a separate file
* Use a conditional to loop over the list of packages to be installed
* install the packages only if current distro is redhat or centos
** if not the case the playbook should fail with the following error message "Host *hostname* does not meet minimal requirements"
* ansible control host has a file /tmp/index.html with contents "Welcome to my webserver"
* if the file is copied sucessfully than httpd must be restarted, if it fails the playbook should show an error message
* firewall must be configured for http and https services

## solution
* check initial-commands.sh first
