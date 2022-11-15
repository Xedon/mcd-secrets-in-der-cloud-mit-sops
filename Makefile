SHELL=/bin/bash

PROFILE=project44

TERRAFORM_IMAGE=hashicorp/terraform:1.3.3

define TERRAFORM_COMMAND
docker run -ti --rm ${PARAMS} --user $$UID:$$GID --env-file <(aws-vault exec ${PROFILE} -- env | grep ^AWS_) \
-v $(PWD):/project -w /project ${TERRAFORM_IMAGE}
endef

login:
	aws-vault login ${PROFILE}

terraform: PARAMS=--entrypoint /bin/sh
terraform:
	${TERRAFORM_COMMAND}

usage-secret-crypt:
	aws-vault exec ${PROFILE} -- sops -e -i usage/secrets.json
usage-secret-decrypt:
	aws-vault exec ${PROFILE} -- sops -d -i usage/secrets.json
usage-secret-edit:
	aws-vault exec ${PROFILE} -- sops usage/secrets.json

setup-init:
	${TERRAFORM_COMMAND} -chdir=setup init

setup-apply:
	${TERRAFORM_COMMAND} -chdir=setup apply

setup-destroy:
	${TERRAFORM_COMMAND} -chdir=setup apply -destroy

usage-init:
	${TERRAFORM_COMMAND} -chdir=usage init

usage-apply:
	${TERRAFORM_COMMAND} -chdir=usage apply

usage-destroy:
	${TERRAFORM_COMMAND} -chdir=usage apply -destroy
