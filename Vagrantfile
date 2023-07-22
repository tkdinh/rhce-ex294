Vagrant.require_version ">= 2.1.0" # 2.1.0 minimum required for triggers



user = ENV['RH_SUBSCRIPTION_MANAGER_USER']
password = ENV['RH_SUBSCRIPTION_MANAGER_PW']
isopath = ENV['RHEL_ISO_PATH']

DISKS_1 = {
  'd1a': ['./small-disk1.qcow2', '400M'],
  'd1b': ['./large-disk1.qcow2', '5G']
}

DISKS_2 = {
  'd2a': ['./small-disk2.qcow2', '400M'],
  'd2b': ['./large-disk2.qcow2', '5G']
}

if !user or !password or !isopath
  puts 'Required environment variables not found. Please set RH_SUBSCRIPTION_MANAGER_USER and RH_SUBSCRIPTION_MANAGER_PW and RHEL_ISO_PATH'
  abort
end

register_script = %{
if ! subscription-manager status; then
  sudo subscription-manager register --username=#{user} --password=#{password} --auto-attach
fi
}

unregister_script = %{
if subscription-manager status; then
  sudo subscription-manager unregister
fi
}

Vagrant.configure("2") do |config|
# Use same SSH key for each machine
# config.ssh.insert_key = false
# config.vm.box_check_update = false

  config.vm.define :repo do |repo|
    repo.vm.box = "joaofcgsilva/rhel9"
    config.vm.synced_folder ".", "/vagrant", type: "rsync",
    rsync__exclude: ".git/"
    repo.vm.provider :libvirt do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
      libvirt.storage :file, :device => :cdrom, :path => isopath
    end

    repo.vm.network :private_network, ip: "10.0.0.10"
    repo.vm.hostname = "repo.rhce-ex294.com"
    repo.vm.provision "shell", inline: register_script

    repo.trigger.before :destroy do |trigger|
      trigger.name = "Before Destroy trigger"
      trigger.info = "Unregistering this VM from RedHat Subscription Manager..."
      trigger.warn = "If this fails, unregister VMs manually at https://access.redhat.com/management/subscriptions"
      trigger.run_remote = {inline: unregister_script}
      trigger.on_error = :continue
    end # trigger.before :destroy
    repo.vm.provision "shell", path: "bootstrap-repo.sh"
  end
  # configuration for node 1
  config.vm.define :node1 do |node1|
    node1.vm.box = "joaofcgsilva/rhel9"
    node1.vm.network :private_network, ip: "10.0.0.101"
    # add two disks of different sizes to node 1
    node1.vm.provider :libvirt do |libvirt|
      DISKS_1.map do |key,value|
        disk_path, disk_size = value
        libvirt.storage :file, :size => disk_size
      end
    end
    node1.vm.provision "shell", path: "bootstrap-nodes.sh"
  end
  # configuration for node 2
  config.vm.define :node2 do |node2|
    node2.vm.box = "joaofcgsilva/rhel9"
    node2.vm.network :private_network, ip: "10.0.0.102"
    # add two disks of different sizes to node 2
    node2.vm.provider :libvirt do |libvirt|
      DISKS_2.map do |key,value|
        disk_path, disk_size = value
        libvirt.storage :file, :size => disk_size
      end
    end
    node2.vm.provision "shell", path: "bootstrap-nodes.sh"
  end
  # configuration for node 3
  config.vm.define :node3 do |node3|
    node3.vm.box = "joaofcgsilva/rhel9"
    node3.vm.network :private_network, ip: "10.0.0.103"
  end
  # configuration for node 4
  config.vm.define :node4 do |node4|
    node4.vm.box = "joaofcgsilva/rhel9"
    node4.vm.network :private_network, ip: "10.0.0.104"
    node4.vm.provision "shell", inline: "touch node4"
  end
  # configuration for control node
  config.vm.define :control do |control|
    control.vm.box = "joaofcgsilva/rhel9"
    control.vm.network :private_network, ip: "10.0.0.100"
    control.vm.provider :libvirt do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end
    control.vm.hostname = "control.rhce-ex294.com"
    control.vm.provision "shell", inline: "touch control"
    control.vm.provision :ansible do |ansible|
      ansible.playbook = "playbooks/master.yml"
      # ansible.install = false
      ansible.compatibility_mode = "2.0"
      ansible.inventory_path = "inventory"
      ansible.config_file = "ansible.cfg"
      ansible.limit = "all"
    end
  end
end
