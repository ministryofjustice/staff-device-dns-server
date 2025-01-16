-include .env
export

.DEFAULT_GOAL := help

DOCKER_COMPOSE = docker compose -f docker-compose.yml

.PHONY: authenticate_docker
authenticate-docker: ## Authenticate docker using ssm paramstore
	./scripts/authenticate_docker.sh

.PHONY: build
build: ## Docker build dns service
	docker build --platform linux/amd64 -t docker_dns ./dns-service

.PHONY: build-nginx
build-nginx: ## Docker build nginx
	docker build --platform linux/amd64 -t nginx ./nginx

.PHONY: push-nginx
push-nginx: ## Docker tag nginx with latest and push to ECR
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag nginx:latest ${REGISTRY_URL}/staff-device-${ENV}-dns-nginx:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns-nginx:latest

.PHONY: push
push: ## Docker tag docker_dns image with latest and push to ECR
	aws ecr get-login-password | docker login --username AWS --password-stdin ${REGISTRY_URL}
	docker tag docker_dns:latest ${REGISTRY_URL}/staff-device-${ENV}-dns:latest
	docker push ${REGISTRY_URL}/staff-device-${ENV}-dns:latest

.PHONY: publish
publish: ## Build docker image, tag and push  docker_dns:latest, build nginx image, tag with latest and push
	$(MAKE) build
	$(MAKE) push
	$(MAKE) build-nginx
	$(MAKE) push-nginx

.PHONY: deploy
deploy: ## Run deploy script
	./scripts/deploy.sh

.PHONEY: build-dev
build-dev: ## Build dev image
	$(DOCKER_COMPOSE) build

.PHONY: stop
stop: ## Stop and remove containers
	$(DOCKER_COMPOSE) down -v

.PHONY: run
run: ## Build dev image and start dns container
	$(MAKE) build-dev
	$(DOCKER_COMPOSE) up -d dns

.PHONY: test
test: ## Build dev container, start dns container, run tests
	$(MAKE) run
	$(MAKE) build-dev
	$(DOCKER_COMPOSE) run --rm dns-test rspec ./metrics/spec
	$(DOCKER_COMPOSE) run --rm dns-test ./dns_test.sh

.PHONY: shell
shell: ## Build dev image and start dns in shell
	$(MAKE) build-dev
	$(DOCKER_COMPOSE) run --rm dns sh

.PHONY: shell-test
shell-test: ## Build dev container and tests in shell
	$(MAKE) build-dev
	$(DOCKER_COMPOSE) run --rm dns-test sh

.PHONY: logs
logs: ## Command will continue streaming the new output from the container's stdout and stderr
	$(DOCKER_COMPOSE) logs --follow

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
