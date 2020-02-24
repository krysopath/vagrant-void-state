# vagrant void state

This configuration creates a reproducible work environment for
me. It will install dependencies and setup simple secret
provisioning.

>I run vagrant with libvirt. Any other provider will work

## requirements

- vault
- client.ovpn + user:pw
- vagrant
- make

## setup with libvirt (optional)

install the dependencies:
```bash
sudo apt-get -y install \
	qemu-kvm \
	virt-top \
	libguestfs-tools \
	virtinst \
	bridge-utils \
	libvirt-dev \
	libvirt-daemon \
	virt-manager \
	vagrant \
	vagrant-libvirt
```

load the required kernel module:
```bash
sudo modprobe vhost_net
lsmod | grep vhost
echo "vhost_net" | sudo tee -a /etc/modules
```

persist that setting in `~/.bashrc` or similar:
```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
```

confirm vagrant-libvirt by:
```
$ vagrant plugin list
vagrant-libvirt (0.0.45, system)
```

## prepare

* place a valid openvpn client certificate/config in `./etc/client.ovpn`
* append this snippet to `./etc/client.ovpn`
```
script-security 2
up /etc/openvpn/update-systemd-resolved
down /etc/openvpn/update-systemd-resolved
down-pre
dhcp-option DOMAIN-ROUTE .
auth-user-pass /vagrant/etc/vpn-auth
```
* place a file `./etc/vpn-auth` with content:
```
username
password
```

## run

```
$ make up
VAULT_TOKEN=s.odvb8y4nrugilngdhkjd vagrant up
Bringing machine 'stateless' up with 'libvirt' provider...
==> stateless: Checking if box 'generic/ubuntu1904' version '2.0.6' is up to date...
==> stateless: Creating image (snapshot of base box volume).
==> stateless: Creating domain with the following settings...
==> stateless:  -- Name:              work_stateless
==> stateless:  -- Domain type:       kvm
==> stateless:  -- Cpus:              2
==> stateless:  -- Feature:           acpi
==> stateless:  -- Feature:           apic
==> stateless:  -- Feature:           pae
==> stateless:  -- Memory:            2048M
==> stateless:  -- Management MAC:
==> stateless:  -- Loader:
==> stateless:  -- Nvram:
==> stateless:  -- Base box:          generic/ubuntu1904
==> stateless:  -- Storage pool:      default
==> stateless:  -- Image:             /var/lib/libvirt/images/work_stateless.img (32G)
==> stateless:  -- Volume Cache:      default
==> stateless:  -- Kernel:
==> stateless:  -- Initrd:
==> stateless:  -- Graphics Type:     vnc
==> stateless:  -- Graphics Port:     -1
==> stateless:  -- Graphics IP:       127.0.0.1
==> stateless:  -- Graphics Password: Not defined
==> stateless:  -- Video Type:        cirrus
==> stateless:  -- Video VRAM:        256
==> stateless:  -- Sound Type:
==> stateless:  -- Keymap:            en-us
==> stateless:  -- TPM Path:
==> stateless:  -- INPUT:             type=mouse, bus=ps2
==> stateless: Pruning invalid NFS exports. Administrator privileges will be required...
==> stateless: Creating shared folders metadata...
==> stateless: Starting domain.
==> stateless: Waiting for domain to get an IP address...
==> stateless: Waiting for SSH to become available...
    stateless:
    stateless: Vagrant insecure key detected. Vagrant will automatically replace
    stateless: this with a newly generated keypair for better security.
    stateless:
    stateless: Inserting generated public key within guest...
    stateless: Removing insecure key from the guest if it's present...
    stateless: Key inserted! Disconnecting and reconnecting using new SSH key...
==> stateless: Setting hostname...
==> stateless: Forwarding ports...
==> stateless: 80 (guest) => 8118 (host) (adapter eth0)
==> stateless: Configuring and enabling network interfaces...
==> stateless: Installing NFS client...
==> stateless: Exporting NFS shared folders...
==> stateless: Preparing to edit /etc/exports. Administrator privileges will be required...
==> stateless: Mounting NFS shared folders...
==> stateless: Running provisioner: shell...
    stateless: Running: /tmp/vagrant-shell20200224-20903-v3fze4
==> stateless: Running provisioner: ansible_local...
    stateless: Installing Ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.9.4).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    stateless: Running ansible-playbook...

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
[DEPRECATION WARNING]: Distribution Ubuntu 19.04 on host stateless should use
/usr/bin/python3, but is using /usr/bin/python for backward compatibility with
prior Ansible releases. A future Ansible release will default to using the
discovered platform python for this host. See https://docs.ansible.com/ansible/
2.9/reference_appendices/interpreter_discovery.html for more information. This
feature will be removed in version 2.12. Deprecation warnings can be disabled
by setting deprecation_warnings=False in ansible.cfg.
ok: [stateless]

TASK [install os deps] *********************************************************
[WARNING]: Updating cache and auto-installing missing dependency: python-apt

changed: [stateless]

TASK [add dockers GPG key for signatures] **************************************
changed: [stateless]
[WARNING]: Consider using the get_url or uri module rather than running 'curl'.
If you need to use command because get_url or uri is insufficient you can add
'warn: false' to this command task or set 'command_warnings=False' in
ansible.cfg to get rid of this message.


TASK [install docker] **********************************************************
changed: [stateless]

TASK [fetch docker-compose] ****************************************************
changed: [stateless]

TASK [configure ecr helper] ****************************************************
changed: [stateless]

TASK [make openvpn always restart] *********************************************
changed: [stateless]

TASK [copy openvpn client conf] ************************************************
changed: [stateless]

TASK [disable DNSSEC for systemd-resolved because systemd is epiko] ************
changed: [stateless]

TASK [extend PATH] *************************************************************
changed: [stateless]

TASK [install pip deps] ********************************************************
[DEPRECATION WARNING]: Invoking "pip" only once while using a loop via
squash_actions is deprecated. Instead of using a loop to supply multiple items
and specifying `name: "{{item}}"`, please use `name: '{{ pip2_deps }}'` and
remove the loop. This feature will be removed in version 2.11. Deprecation
warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
changed: [stateless] => (item=[u'j2'])

TASK [clone asdf] **************************************************************
changed: [stateless]

TASK [load asdf context] *******************************************************
changed: [stateless]

TASK [load asdf context] *******************************************************
changed: [stateless]

TASK [install asdf pugins] *****************************************************
changed: [stateless] => (item={u'ver': u'3.1.1', u'name': u'helm'})
changed: [stateless] => (item={u'ver': u'1.17.3', u'name': u'kubectl'})
changed: [stateless] => (item={u'ver': u'0.10.4', u'name': u'nomad'})
changed: [stateless] => (item={u'ver': u'0.12.21', u'name': u'terraform'})
changed: [stateless] => (item={u'ver': u'0.22.4', u'name': u'terragrunt'})
changed: [stateless] => (item={u'ver': u'1.3.0', u'name': u'vault'})

TASK [create a vaultified direnv .envrc for vagrant] ***************************
changed: [stateless]

TASK [allow /home/vagrant/.envrc] **********************************************
changed: [stateless]

TASK [enable direnv hooks] *****************************************************
changed: [stateless]

RUNNING HANDLER [daemon reload] ************************************************
ok: [stateless]

RUNNING HANDLER [restart systemd-resolved] *************************************
changed: [stateless]

RUNNING HANDLER [restart openvpn] **********************************************
changed: [stateless]

RUNNING HANDLER [sleep for openvpn] ********************************************
ok: [stateless]

PLAY RECAP *********************************************************************
stateless                  : ok=22   changed=19   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


$ vagrant ssh
direnv: loading .envrc
direnv: export +AWS_ACCESS_KEY_ID +AWS_DEFAULT_REGION +AWS_ECR_REPOSITORY +AWS_SECRET_ACCESS_KEY +CROWDIN_PROJECT_ID +CROWDIN_TOKEN +NPM_TOKEN +SONAR_TOKEN +TAXJAR_TOKEN +VAULT_ADDR
vagrant@void-state:~$ docker pull 0123456789.dkr.ecr.eu-central-1.amazonaws.com/coma:3.1415
3.16.2: Pulling from 3yd-yoda
4167d3e14976: Pull complete
db94a93dfca0: Pull complete
50b16383aa44: Pull complete
3554ae33a3b1: Pull complete
cb62aeb9c52c: Pull complete
37eda6552db0: Pull complete
32270412364f: Pull complete
c9761687a7f3: Pull complete
b1023914253d: Pull complete
e7f912208cab: Pull complete
a0d258526e1d: Pull complete
Digest: sha256:fe93f02ed903251a4ce86f33ed8532298d5f9662aa7584a1e9689daaa731c232
Status: Downloaded newer image for 0123456789.dkr.ecr.eu-central-1.amazonaws.com/coma:3.1415
0123456789.dkr.ecr.eu-central-1.amazonaws.com/coma:3.1415
```
