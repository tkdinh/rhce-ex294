Vagrant.configure("2") do |config|
# Use same SSH key for each machine
# config.ssh.insert_key = false
# config.vm.box_check_update = false




  config.vm.define :repo do |repo|
    repo.vm.box = "generic/rhel9"
    #repo.vm.provision "shell", inline: "touch cenas"
    repo.vm.network :private_network, ip: "10.0.0.10"
    repo.vm.hostname = "repo.rhce-ex294.com"
  end
  # configuration for control node
  config.vm.define :control do |control|
    control.vm.box = "generic/rhel9"
    control.vm.network :private_network, ip: "10.0.0.100"
    control.vm.hostname = "control.rhce-ex294.com"
    control.vm.provision "shell", inline: "touch control"
  end
  # configuration for node 1
  config.vm.define :node1 do |node1|
    node1.vm.box = "generic/rhel9"
    node1.vm.network :private_network, ip: "10.0.0.101"
    node1.vm.provision "shell", path: "bootstrap-nodes.sh"
  end
  # configuration for node 2
#  config.vm.define :node2 do |node2|
#    node2.vm.box = "generic/rhel9"
#    node2.vm.network :private_network, ip: "10.0.0.102"
#    node2.vm.provision "shell", inline: "touch node2"
#  end
#  # configuration for node 3
#  config.vm.define :node3 do |node3|
#    node3.vm.box = "generic/rhel9"
#    node3.vm.network :private_network, ip: "10.0.0.103"
#    node3.vm.provision "shell", inline: "touch node3"
#  end
#  # configuration for node 4
#  config.vm.define :node4 do |node4|
#    node4.vm.box = "generic/rhel9"
#    node4.vm.network :private_network, ip: "10.0.0.104"
#    node4.vm.provision "shell", inline: "touch node4"
#  end
#  # configuration for node 5
#  config.vm.define :node4 do |node4|
#    node4.vm.box = "generic/rhel9"
#    node4.vm.network :private_network, ip: "10.0.0.105"
#    node4.vm.provision "shell", inline: "touch node5"
#  end
end
