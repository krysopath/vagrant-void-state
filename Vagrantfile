# -*- mode: ruby -*-
# vi: set ft=ruby :

MEMORY_MB = "4096"
NUM_CORES = 6

Vagrant.configure("2") do |config|
  config.vm.define "stateless" do |stateless|

    stateless.vm.provider "libvirt" do |v|
      v.memory = MEMORY_MB
      v.cpus = NUM_CORES
    end

    stateless.vm.provider "virtualbox" do |v|
      v.memory = MEMORY_MB
      v.cpus = NUM_CORES
    end

    stateless.vm.network "private_network", ip: "10.10.10.10"

    stateless.vm.box = "generic/ubuntu1904"
    stateless.vm.hostname = "void-state"
    stateless.vm.network "forwarded_port", guest: 80, host: 8080
    stateless.vm.network "forwarded_port", guest: 443, host: 8443
    stateless.vm.synced_folder "etc", "/vagrant/etc"
    stateless.vm.synced_folder "src", "/home/vagrant/src"
    stateless.vm.synced_folder "~/.ssh/", "/home/vagrant/.ssh"

    stateless.ssh.forward_agent = true
    stateless.ssh.keys_only = false
    stateless.ssh.private_key_path = [
      "~/.vagrant.d/insecure_private_key",
	  "~/.ssh/id_rsa",
    ]
    stateless.ssh.forward_env = [
      "VAULT_TOKEN",
      "VAULT_ADDR",
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY"
    ]

    stateless.vm.provision "ansible_local" do |a|
      a.compatibility_mode  = "2.0"
      a.playbook = "/vagrant/etc/provide.yml"
      a.extra_vars = {
        vault_token: ENV['VAULT_TOKEN'],
        asdf_tools: true
      }
    end
  end
end
