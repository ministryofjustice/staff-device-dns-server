DOCKER_COMPOSE = docker-compose -f docker-compose.yml

build:
	docker build -t docker_dns ./dns-service

deploy: build
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag docker_dns:latest ${REGISTRY_URL}/staff-device-${ENV}-dns-docker-dns:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns-docker-dns:latest

build-dev:
	$(DOCKER_COMPOSE) build

stop:
	$(DOCKER_COMPOSE) down -v

run: 
	$(DOCKER_COMPOSE) up --build

test:
	echo "no test yet"

shell:
	$(DOCKER_COMPOSE) run --rm dns bin/sh

.PHONY: build deploy test shell stop build-dev
