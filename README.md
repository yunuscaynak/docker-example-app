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
