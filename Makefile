DOCKER_COMPOSE = docker-compose -f docker-compose.yml

check-container-registry-account-id:
	./scripts/check_container_registry_account_id

build: check-container-registry-account-id
	./scripts/build

deploy:
	./scripts/deploy

build-dev: check-container-registry-account-id
	$(DOCKER_COMPOSE) build --build-arg ACCOUNT_ID=${ACCOUNT_ID}

publish: build
	./scripts/publish

stop:
	$(DOCKER_COMPOSE) down -v

run: build-dev
	$(DOCKER_COMPOSE) up -d dns

test: run
	$(DOCKER_COMPOSE) run --rm dns-test ./dns_test

shell: build-dev
	$(DOCKER_COMPOSE) run --rm dns sh

.PHONY: build deploy test shell stop build-dev
