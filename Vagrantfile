# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "stateless" do |stateless|
    stateless.vm.provider "libvirt" do |v|
      v.memory = 4096
      v.cpus = 4
    end

    stateless.vm.box = "generic/ubuntu1904"
    stateless.vm.hostname = "void-state"
    stateless.vm.network "forwarded_port", guest: 80, host: 8118
    stateless.vm.synced_folder "etc", "/vagrant/etc"
    stateless.vm.synced_folder "src", "/home/vagrant/src"


    stateless.vm.provision "shell",
      path: "/vagrant/etc/vault-login",
      env: {"VAULT_TOKEN" => ENV['VAULT_TOKEN']}

    stateless.vm.provision "ansible_local" do |a|
      a.playbook = "/vagrant/etc/provide.yml"
    end

  end
end
