.PHONY: help npm-install npm-start npm-dev \
        dev prod stop \
        dev-down dev-logs dev-ps \
        prod-down prod-logs prod-ps \
        api-health api-forms-get api-forms-post test-post \
        db-count db-last

# Docker Compose dosyalari
DEV_FILE := docker/compose/dev.yml
PROD_FILE := docker/compose/prod.yml
DEV_COMPOSE := docker compose -f $(DEV_FILE)
PROD_COMPOSE := docker compose -f $(PROD_FILE)

# Hosttan API istekleri icin temel adres
PORT ?= 3001
API_URL ?= http://localhost:$(PORT)
LIMIT ?= 20

# Form post istegi icin varsayilan degerler
FORM_NAME ?= TestUser
FORM_EMAIL ?= test@example.com
FORM_MESSAGE ?= Merhaba

# Mongo icindeki sorgu hedefi
MONGO_DB ?= form_app_db
MONGO_COLLECTION ?= forms
MONGO_SERVICE ?= mongo

help:
	@echo "Kullanim: make <target> [VAR=deger]"
	@echo ""
	@echo "Hizli Komutlar"
	@echo "  make dev"
	@echo "  make prod"
	@echo "  make stop"
	@echo "  make test-post"
	@echo ""
	@echo "Node"
	@echo "  make npm-install"
	@echo "  make npm-start"
	@echo "  make npm-dev"
	@echo ""
	@echo "Docker Dev"
	@echo "  make dev-down"
	@echo "  make dev-logs"
	@echo "  make dev-ps"
	@echo ""
	@echo "Docker Prod"
	@echo "  make prod-down"
	@echo "  make prod-logs"
	@echo "  make prod-ps"
	@echo ""
	@echo "API"
	@echo "  make api-health"
	@echo "  make api-forms-get LIMIT=10"
	@echo "  make api-forms-post FORM_NAME=Ali FORM_EMAIL=ali@example.com FORM_MESSAGE=Merhaba"
	@echo ""
	@echo "Mongo"
	@echo "  make db-count"
	@echo "  make db-last"

# Lokal node komutlari
npm-install:
	npm install

npm-start:
	npm start

npm-dev:
	npm run dev

# Tek komutta sik kullanilan akislar
dev:
	$(DEV_COMPOSE) up -d --build

prod:
	$(PROD_COMPOSE) up -d --build

stop:
	$(DEV_COMPOSE) down
	$(PROD_COMPOSE) down

test-post: FORM_NAME=Ali Veli
test-post: FORM_EMAIL=ali@example.com
test-post: FORM_MESSAGE=Merhaba
test-post: api-forms-post

dev-down:
	$(DEV_COMPOSE) down

dev-logs:
	$(DEV_COMPOSE) logs -f

dev-ps:
	$(DEV_COMPOSE) ps

prod-down:
	$(PROD_COMPOSE) down

prod-logs:
	$(PROD_COMPOSE) logs -f

prod-ps:
	$(PROD_COMPOSE) ps

# Uygulama endpoint testleri
api-health:
	curl -sS "$(API_URL)/api/health"

api-forms-get:
	curl -sS "$(API_URL)/api/forms?limit=$(LIMIT)"

api-forms-post:
	curl -sS -X POST "$(API_URL)/api/forms" \
	  -H "Content-Type: application/json" \
	  -d "{\"name\":\"$(FORM_NAME)\",\"email\":\"$(FORM_EMAIL)\",\"message\":\"$(FORM_MESSAGE)\"}"

# Mongo icinde hizli kontrol sorgulari
db-count:
	$(DEV_COMPOSE) exec -T $(MONGO_SERVICE) mongosh --quiet --eval "db.getSiblingDB('$(MONGO_DB)').$(MONGO_COLLECTION).countDocuments()"

db-last:
	$(DEV_COMPOSE) exec -T $(MONGO_SERVICE) mongosh --quiet --eval "db.getSiblingDB('$(MONGO_DB)').$(MONGO_COLLECTION).find().sort({createdAt:-1}).limit(1).toArray()"
