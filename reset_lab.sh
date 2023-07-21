#!/bin/bash
vagrant halt
vagrant destroy -f node1 node2 node3 node4 control
#vagrant up