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

    stateless.vm.provider "aws" do |aws|
      aws.instance_type = "t3.medium"
      aws.keypair_name = "Georg"
      aws.monitoring = false
      aws.region = "eu-central-1"
      aws.subnet_id = "vpc-3f52bc56"
      aws.ami = "ami-066866b740d9ce5a7"
    end

    stateless.vm.network "private_network", ip: "10.10.10.10"

    stateless.vm.box = "generic/ubuntu1904"
    stateless.vm.hostname = "void-state"
    stateless.vm.network "forwarded_port", guest: 80, host: 8080
    stateless.vm.network "forwarded_port", guest: 443, host: 8443
    stateless.vm.synced_folder "etc", "/vagrant/etc"
    stateless.vm.synced_folder "~/.gnupg", "/home/vagrant/.gnupg"

    stateless.ssh.forward_agent = true
    stateless.ssh.forward_env = [
      "VAULT_TOKEN",
      "VAULT_ADDR",
      "VAULT_PATHS",
      "AWS_ACCESS_KEY_ID",
      "AWS_SECRET_ACCESS_KEY"
    ]

    stateless.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
    stateless.vm.provision "file", source: "~/.ssh/known_hosts", destination: "~/.ssh/known_hosts"

    stateless.vm.provision "ansible_local" do |a|
      a.compatibility_mode  = "2.0"
      a.playbook = "/vagrant/etc/provide.yml"
      a.extra_vars = {
        apt: {
          cache_valid: 3600,
          latest: true
        },
        vault_token: ENV['VAULT_TOKEN'],
        git: {
          repos: [
            {src: "git@bitbucket.org:3yourmind/polyrepo.git", dest: "~/src/3yourmind/polyrepo/"},
            {src: "git@bitbucket.org:3yourmind/button3d.git", dest: "~/src/3yourmind/button3d"},
            {src: "git@bitbucket.org:3yourmind/3yd-nginx.git", dest: "~/src/3yourmind/3yd-nginx"},
            {src: "git@bitbucket.org:3yourmind/yoda.git", dest: "~/src/3yourmind/yoda"},
            {src: "git@bitbucket.org:3yourmind/backend_spring.git", dest: "~/src/3yourmind/backend_spring"},
            {src: "git@bitbucket.org:3yourmind/devops.git", dest: "~/src/3yourmind/devops"},
            {src: "git@bitbucket.org:3yourmind/e2e-tests.git", dest: "~/src/3yourmind/e2e-tests"},
            {src: "git@bitbucket.org:3yourmind/3yourmind.git", dest: "~/src/3yourmind/3yourmind"},
          ],
          clone: false,
        },
        AcceptEnv: ["VAULT_*", "AWS_*"],
        docker_compose: "1.25.4",
        dotfiles: {
          src: "git@github.com:krysopath/dotfiles.git",
          dest: '~/.dotfiles',
          version: 'master',
          active: true,
          clone: true,
          checkout: true,
          force: true,
        },
        asdf: {
          refresh: true,
          version: "v0.7.6",
          path: "~/.asdf/bin/asdf",
          plugins: [
            {name: "helm", ver: "3.1.1"},
            {name: "kubectl", ver: "1.17.3"},
            {name: "nomad", ver: "0.10.4"},
            {name: "terraform", ver: "0.12.21"},
            {name: "terragrunt", ver: "0.22.4"},
            {name: "vault", ver: "1.3.0"},
            {name: "k9s", ver: "0.16.1"},
          ],
        },
        pip2_deps: ["j2"],
        docker_deps: [
          "docker-ce",
          "docker-ce-cli",
          "amazon-ecr-credential-helper",
        ],
        os_deps: [
          "apt-transport-https",
          "ca-certificates",
          "curl",
          "software-properties-common",
          "awscli",
          "jq",
          "python3-pip",
          "python-pip",
          "direnv",
          "openvpn",
          "openvpn-systemd-resolved",
        ],
      }
    end
  end
end
