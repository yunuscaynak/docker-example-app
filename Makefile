.PHONY: dev dev-build dev-down dev-logs prod-build prod-run prod-stop

APP_NAME := app-prod
PORT := 3001

dev:
	docker compose -f docker/compose/dev.yml up

dev-build:
	docker compose -f docker/compose/dev.yml up --build

dev-down:
	docker compose -f docker/compose/dev.yml down

dev-logs:
	docker compose -f docker/compose/dev.yml logs -f

prod-build:
	docker build -t $(APP_NAME) -f docker/prod/Dockerfile .

prod-run:
	docker run --rm -p $(PORT):$(PORT) --name $(APP_NAME) $(APP_NAME)

prod-stop:
	docker stop $(APP_NAME)
