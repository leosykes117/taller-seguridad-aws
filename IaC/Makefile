all: terraform

AWS_PROFILE=
CMD=
OTHER_VARS=

.PHONY: terraform
terraform:
	docker run -it --rm \
	-w /home/terraform/project \
	--mount type=bind,source=${HOME}/.aws,destination=/home/terraform/.aws,readonly \
	--mount type=bind,source=${PWD},destination=/home/terraform/project \
	--mount type=bind,source=${PWD}/../services,destination=/home/terraform/services/ \
	--name terraform \
	hashicorp/terraform ${CMD} -var "aws_profile=${AWS_PROFILE}" ${OTHER_VARS}