VTOKEN=vault token create -ttl=768h -format=json -policy devops | jq -r .auth.client_token

up:
	@VAULT_TOKEN=$(shell $(VTOKEN)) vagrant up

provision:
	@VAULT_TOKEN=$(shell $(VTOKEN)) vagrant provision
