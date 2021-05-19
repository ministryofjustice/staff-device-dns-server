#!make
include .env
export

DOCKER_COMPOSE = docker-compose -f docker-compose.yml

authenticate-docker:
	./scripts/authenticate_docker.sh

check-container-registry-account-id:
	./scripts/check_container_registry_account_id.sh

build: check-container-registry-account-id
	docker build -t docker_dns ./dns-service --build-arg SHARED_SERVICES_ACCOUNT_ID

build-nginx:
	docker build -t nginx ./nginx --build-arg SHARED_SERVICES_ACCOUNT_ID

push-nginx:
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag nginx:latest ${REGISTRY_URL}/staff-device-${ENV}-dns-nginx:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns-nginx:latest

push:
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag docker_dns:latest ${REGISTRY_URL}/staff-device-${ENV}-dns:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns:latest

publish: build push build-nginx push-nginx

deploy:
	./scripts/deploy.sh

build-dev:
	$(DOCKER_COMPOSE) build

stop:
	$(DOCKER_COMPOSE) down -v

run: build-dev
	$(DOCKER_COMPOSE) up -d dns

test: run build-dev
	$(DOCKER_COMPOSE) run --rm dns-test rspec ./metrics/spec
	$(DOCKER_COMPOSE) run --rm dns-test ./dns_test.sh

shell: build-dev
	$(DOCKER_COMPOSE) run --rm dns sh

shell-test: build-dev
	$(DOCKER_COMPOSE) run --rm dns-test sh

logs: 
	$(DOCKER_COMPOSE) logs --follow

.PHONY: build push publish deploy build-dev stop run test shell shell-test logs authenticate-docker check-container-registry-account-id
