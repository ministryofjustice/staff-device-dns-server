DOCKER_COMPOSE = docker-compose -f docker-compose.yml

authenticate-docker:
	./scripts/authenticate_docker

check-container-registry-account-id:
	./scripts/check_container_registry_account_id

build: check-container-registry-account-id
	docker build -t docker_dns ./dns-service --build-arg SHARED_SERVICES_ACCOUNT_ID

build-nginx:
	docker build -t nginx ./nginx --build-arg SHARED_SERVICES_ACCOUNT_ID

push-nginx:
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag nginx:latest ${REGISTRY_URL}/staff-device-${ENV}-dns-docker-nginx:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns-docker-nginx:latest

push:
	echo ${REGISTRY_URL}
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag docker_dns:latest ${REGISTRY_URL}/staff-device-${ENV}-dns-docker:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns-docker:latest

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
	$(DOCKER_COMPOSE) logs

.PHONY: build publish test shell stop start-db build-dev deploy
