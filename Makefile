VTOKEN=vault token create -ttl=168h -format=json -policy devops | jq -r .auth.client_token
VAULT_TOKEN ?= $(shell $(VTOKEN))

up:
	@VAULT_TOKEN=$(VAULT_TOKEN) vagrant up

provision: up
	@VAULT_TOKEN=$(VAULT_TOKEN) vagrant provision

ssh: up
	@VAULT_TOKEN=$(VAULT_TOKEN) vagrant ssh
