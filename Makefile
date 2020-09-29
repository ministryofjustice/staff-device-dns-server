DOCKER_COMPOSE = docker-compose -f docker-compose.yml

build:
	docker build -t docker_dns ./dns-service

deploy: build
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag docker_dns:latest ${REGISTRY_URL}/staff-device-${ENV}-dns-docker:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns-docker:latest

build-dev:
	$(DOCKER_COMPOSE) build

stop:
	$(DOCKER_COMPOSE) down -v

run:
	$(DOCKER_COMPOSE) up --build dns

test:
	$(DOCKER_COMPOSE) run --rm dns-test ./dns_test

shell:
	$(DOCKER_COMPOSE) run --rm dns sh

.PHONY: build deploy test shell stop build-dev
