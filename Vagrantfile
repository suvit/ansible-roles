# -*- mode: ruby -*-
# vi: set ft=ruby :


def has_plugins?(plugins)
    if plugins.map { |i| Vagrant.has_plugin? i }.include? false
        puts "Install required plugins with\n\n"
        puts "  vagrant plugin install #{plugins.join(' ')}"
        exit(false)
    end
end
has_plugins? %w(vagrant-cachier vagrant-hostmanager)


Vagrant.configure(2) do |config|
  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = true
  config.vm.network "private_network", ip: "192.168.33.33"

  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.ssh.private_key_path = ["~/.vagrant.d/insecure_private_key", "~/.ssh/id_rsa"]

  config.cache.scope = :box  # vagrant-cachier

  # vagrant-hostmanager
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.hostmanager.ignore_private_ip = false

    config.vm.define 'ansible-test' do |node|
      node.vm.hostname = 'ansible.box'
    end
  # end vagrant-hostmanager

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
  end

  config.vm.provision "file",
    source: "~/.ssh/id_rsa.pub",
    destination: "/tmp/authorized_keys"

  config.vm.provision "shell", inline: <<-SHELL
    set -e
    sed -i'' -r "/^$|^#|^deb-src.*/d" /etc/apt/sources.list
    mkdir -p -m 0700 /root/.ssh
    cp /tmp/authorized_keys /root/.ssh
    chown -R root.root /root/.ssh
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "site.yml"
    ansible.extra_vars = {
      ansible_ssh_user: 'root'
    }
  end
end
