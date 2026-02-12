.PHONY: help npm-install npm-start npm-dev npm-test dev dev-build dev-down dev-restart dev-logs dev-ps \
        prod-up prod-down prod-restart prod-logs prod-build prod-run prod-stop prod-rm \
        image-build image-ls image-history image-inspect \
        hub-tag hub-push hub-pull hub-run \
        status logs shell restart clean

APP_NAME ?= docker-ornek
CONTAINER_NAME ?= docker-ornek
PORT ?= 3001
TAG ?= latest
DOCKER_USER ?= yunuscaynak

DEV_FILE := docker/compose/dev.yml
PROD_FILE := docker/compose/prod.yml
DEV_COMPOSE := docker compose -f $(DEV_FILE)
PROD_COMPOSE := docker compose -f $(PROD_FILE)
IMAGE_LOCAL := $(APP_NAME):$(TAG)
IMAGE_REMOTE := $(DOCKER_USER)/$(APP_NAME):$(TAG)

help:
	@echo "Kullanim: make <target> [VAR=deger]"
	@echo ""
	@echo "Node scripts"
	@echo "  make npm-install    -> npm install"
	@echo "  make npm-start      -> npm start"
	@echo "  make npm-dev        -> npm run dev"
	@echo "  make npm-test       -> npm test"
	@echo ""
	@echo "Dev compose"
	@echo "  make dev            -> dev compose up"
	@echo "  make dev-build      -> dev compose up --build"
	@echo "  make dev-down       -> dev compose down"
	@echo "  make dev-restart    -> dev down + up"
	@echo "  make dev-logs       -> dev log takip"
	@echo ""
	@echo "Prod compose"
	@echo "  make prod-up        -> prod compose up -d --build"
	@echo "  make prod-down      -> prod compose down"
	@echo "  make prod-restart   -> prod down + up"
	@echo "  make prod-logs      -> prod log takip"
	@echo ""
	@echo "Image"
	@echo "  make image-build    -> docker/prod/Dockerfile ile build"
	@echo "  make image-ls       -> local image listesi"
	@echo "  make image-history  -> image katmanlari"
	@echo ""
	@echo "Registry"
	@echo "  make hub-push TAG=v2"
	@echo "  make hub-pull TAG=v2"
	@echo "  make hub-run TAG=v2"
	@echo ""
	@echo "Container"
	@echo "  make status         -> container listesi"
	@echo "  make logs           -> container logs -f"
	@echo "  make shell          -> container shell"
	@echo "  make restart        -> container restart"
	@echo "  make clean          -> kullanilmayan container/image temizligi"

npm-install:
	npm install

npm-start:
	npm start

npm-dev:
	npm run dev

npm-test:
	npm test

dev:
	$(DEV_COMPOSE) up

dev-build:
	$(DEV_COMPOSE) up --build

dev-down:
	$(DEV_COMPOSE) down

dev-restart:
	$(DEV_COMPOSE) down
	$(DEV_COMPOSE) up -d --build

dev-logs:
	$(DEV_COMPOSE) logs -f

dev-ps:
	$(DEV_COMPOSE) ps

prod-up:
	$(PROD_COMPOSE) up -d --build

prod-down:
	$(PROD_COMPOSE) down

prod-restart:
	$(PROD_COMPOSE) down
	$(PROD_COMPOSE) up -d --build

prod-logs:
	$(PROD_COMPOSE) logs -f

prod-build:
	docker build -t $(IMAGE_LOCAL) -f docker/prod/Dockerfile .

prod-run:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):3001 $(IMAGE_LOCAL)

prod-stop:
	docker stop $(CONTAINER_NAME)

prod-rm:
	docker rm $(CONTAINER_NAME)

image-build:
	docker build -t $(IMAGE_LOCAL) -f docker/prod/Dockerfile .

image-ls:
	docker images

image-history:
	docker history $(IMAGE_LOCAL)

image-inspect:
	docker image inspect $(IMAGE_LOCAL)

hub-tag:
	docker tag $(IMAGE_LOCAL) $(IMAGE_REMOTE)

hub-push: hub-tag
	docker push $(IMAGE_REMOTE)

hub-pull:
	docker pull $(IMAGE_REMOTE)

hub-run:
	docker run -d --name $(CONTAINER_NAME) -p $(PORT):3001 $(IMAGE_REMOTE)

status:
	docker ps -a

logs:
	docker logs -f $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) sh

restart:
	docker restart $(CONTAINER_NAME)

clean:
	docker container prune -f
	docker image prune -f
