# Docker Notes

Bu repo, Docker ogrenme notlarini ve pratik komut orneklerini icerir.

## Ana Dokuman

Detayli komutlar ve aciklamalar burada:

- [dockerKomutlari.md](dockerKomutlari.md)

## Hedef

- Docker image/container yonetimi
- Dockerfile ve Docker Compose kullanimi
- Dev/Prod ayrimi
- Docker Hub push/pull sureci
- Troubleshooting ve best practices

## Hizli Baslangic

```bash
# Dev
docker compose -f docker/compose/dev.yml up -d --build

# Prod
docker compose -f docker/compose/prod.yml up -d --build
```

## Makefile ile Kisa Kullanim

Tek komutla proje operasyonlari:

```bash
# yardim
make help

# node scripts
make npm-install
make npm-start
make npm-dev

# dev
make dev-build
make dev-logs

# prod
make prod-up TAG=v2
make prod-logs

# docker hub
make hub-push TAG=v2
```
