# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "stateless" do |stateless|
    stateless.vm.provider "libvirt" do |v|
      v.memory = 4096
      v.cpus = 6
    end

    stateless.vm.box = "generic/ubuntu1904"
    stateless.vm.hostname = "void-state"
    stateless.vm.network "forwarded_port", guest: 80, host: 8080
    stateless.vm.network "forwarded_port", guest: 443, host: 8443
    stateless.vm.synced_folder "etc", "/vagrant/etc"
    stateless.vm.synced_folder "src", "/home/vagrant/src"

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
