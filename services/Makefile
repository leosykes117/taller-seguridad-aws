all: bin/example
test: lint unit-test

PLATFORM=local
PROJECT=

.PHONY: bin/example
bin/example:
	@docker buildx build . --target bin \
	--output ${PROJECT}/bin/ \
	--build-arg PROJECT=${PROJECT} \
	--platform ${PLATFORM}

.PHONY: mod-init
mod-init:
	@docker buildx build . --target get-mod \
	--output . \
	--build-arg NAME=${PROJECT} \
	--platform ${PLATFORM}

.PHONY: tidy
tidy:
	@docker buildx build . --target tidy \
	--build-arg NAME=${PROJECT} \
	--platform ${PLATFORM}

.PHONY: unit-test
unit-test:
	@docker build . --target unit-test

.PHONY: unit-test-coverage
unit-test-coverage:
	@docker build . --target unit-test-coverage \
	--output ${PROJECT}/coverage/
	cat coverage/cover.out

.PHONY: lint
lint:
	@docker build . --target lint
