DOCKER_COMPOSE = docker-compose -f docker-compose.yml

build:
	./scripts/build

deploy:
	./scripts/deploy

build-dev:
	$(DOCKER_COMPOSE) build

publish: build
	./scripts/publish

stop:
	$(DOCKER_COMPOSE) down -v

run:
	$(DOCKER_COMPOSE) up -d --build dns

test: run
	$(DOCKER_COMPOSE) run --rm dns-test ./dns_test

shell:
	$(DOCKER_COMPOSE) run --rm dns sh

.PHONY: build deploy test shell stop build-dev
