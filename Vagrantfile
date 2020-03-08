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
      "VAULT_PATHS",
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY"
    ]

    stateless.vm.provision "ansible_local" do |a|
      a.compatibility_mode  = "2.0"
      a.playbook = "/vagrant/etc/provide.yml"
      a.extra_vars = {
        vault_token: ENV['VAULT_TOKEN'],
        asdf_tools: true,
        clone_git: [
          {"src": "git@bitbucket.org:3yourmind/polyrepo.git", "dest": "~/src/3yourmind/polyrepo/"},
          {"src": "git@bitbucket.org:3yourmind/button3d.git", "dest": "~/src/3yourmind/polyrepo/button3d"},
          {"src": "git@bitbucket.org:3yourmind/3yd-nginx.git", "dest": "~/src/3yourmind/polyrepo/3yd-nginx"},
          {"src": "git@bitbucket.org:3yourmind/yoda.git", "dest": "~/src/3yourmind/polyrepo/yoda"},
          {"src": "git@bitbucket.org:3yourmind/backend_spring.git", "dest": "~/src/3yourmind/polyrepo/backend_spring"},
          {"src": "git@bitbucket.org:3yourmind/devops.git", "dest": "~/src/3yourmind/polyrepo/devops"},
          {"src": "git@bitbucket.org:3yourmind/e2e-tests.git", "dest": "~/src/3yourmind/polyrepo/e2e-tests"},
          {"src": "git@bitbucket.org:3yourmind/3yourmind.git", "dest": "~/src/3yourmind/polyrepo/3yourmind"},
        ],
      }
    end
  end
end
