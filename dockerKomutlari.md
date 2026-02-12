# Docker Komutlari (Proje Notlari)

Bu dosya, proje icin kullanilan temel Docker komutlarini ve kisa aciklamalarini icerir.

## 1. Image olusturma (build)

```bash
docker build -t docker-ornek:latest -f docker/prod/Dockerfile .
```

Not: Bu projede Dockerfile'lar `docker/prod/Dockerfile` ve `docker/dev/Dockerfile` altindadir, bu yuzden `-f` ile belirtmelisin.

```bash
docker build -f docker/dev/Dockerfile -t docker-ornek:dev .
```

Alternatif: dogrudan v2 etiketiyle build

```bash
docker build -t docker-ornek:v2 -f docker/prod/Dockerfile .
```

## 2. Image listeleme

```bash
docker images
```

Ek: Image katmanlari ve boyut analizi

```bash
docker history docker-ornek:latest
docker image inspect docker-ornek:latest --format='{{.Size}}'
```

## 3. Container calistirma

```bash
docker run -d --name docker-ornek -p 3001:3001 docker-ornek:latest
```

Not: `-p 3001:3001` olmadan tarayicidan erisim olmaz.

## 3.1 Port mapping (host:container)

Format:

```bash
docker run -p HOST_PORT:CONTAINER_PORT IMAGE
```

Ornekler:

```bash
# Host 3001 portunu container icindeki 3001 portuna baglar
docker run -d --name docker-ornek -p 3001:3001 docker-ornek:latest

# Host 8080 portunu container icindeki 3001 portuna baglar
docker run -d --name docker-ornek -p 8080:3001 docker-ornek:latest
```

Notlar:
- `HOST_PORT`: Tarayicidan girdigin port (ornegin `http://localhost:8080`).
- `CONTAINER_PORT`: Uygulamanin container icinde dinledigi port (bu projede `3001`).
- Bir container icin ayni `HOST_PORT` baska bir container tarafindan kullaniliyorsa calismaz.

## 4. Container durumunu gorme

```bash
docker ps
docker ps -a
```

## 5. Loglari gorme

```bash
docker logs docker-ornek
```

Gelişmiş kullanim:

```bash
# Son 100 satir
docker logs --tail 100 docker-ornek

# Canli takip
docker logs -f docker-ornek

# Zaman damgali
docker logs -t docker-ornek
```

## 6. Container durdurma / silme / yeniden baslatma

```bash
docker stop docker-ornek
docker rm docker-ornek
docker start docker-ornek
```

## 7. Image tagleme (versiyonlama)

```bash
docker tag docker-ornek:latest docker-ornek:v2
```

## 8. Docker Hub'a push

```bash
docker login
docker tag docker-ornek:v2 yunuscaynak/docker-ornek:v2
docker push yunuscaynak/docker-ornek:v2
```

## 9. Docker Hub'dan cekip calistirma

```bash
docker pull yunuscaynak/docker-ornek:v2
docker run -d --name docker-ornek -p 3001:3001 yunuscaynak/docker-ornek:v2
```

## 10. Dockerfile (kisa ozet)

Dockerfile, image'in nasil olusacagini tanimlar. Bu projede:
- `FROM node:18-alpine` temel image
- `WORKDIR /app` calisma dizini
- `COPY` ve `RUN` ile bagimliliklar ve kod kopyalanir
- `EXPOSE 3001` container portu
- `CMD ["node", "app.js"]` calistirilacak komut

Dosyalar:
- Prod: `docker/prod/Dockerfile`
- Dev: `docker/dev/Dockerfile`

## 10.1 Prod vs Dev Dockerfile

Farklar:
- Bagimlilik: Prod -> `npm ci --only=production`, Dev -> `npm install`
- Calistirma: Prod -> `node app.js`, Dev -> `npm run dev`
- Amac: Prod stabil/kalici, Dev gelistirme (hot-reload)

Dev image build:

```bash
docker build -f docker/dev/Dockerfile -t docker-ornek:dev .
```

Dev container calistirma:

```bash
docker run -d --name docker-ornek-dev -p 3001:3001 docker-ornek:dev
```

Prod image build:

```bash
docker build -f docker/prod/Dockerfile -t docker-ornek:latest .
```

## 11. Docker Compose (docker/compose/dev.yml)

Birden fazla servisi tek komutla yonetmek icin kullanilir.

Calistirma:

```bash
docker compose -f docker/compose/dev.yml up -d
```

Durdurma:

```bash
docker compose -f docker/compose/dev.yml down
```

Loglari gorme:

```bash
docker compose -f docker/compose/dev.yml logs -f
```

Not: `docker/compose/dev.yml` icindeki `ports` ayari, port mapping'i belirler.

Ek komutlar:

```bash
# Sadece belirli servisi calistir
docker compose -f docker/compose/dev.yml up -d app

# Servisleri yeniden build et
docker compose -f docker/compose/dev.yml up -d --build

# Servisleri olceklendir
docker compose -f docker/compose/dev.yml up -d --scale app=3
```

Prod icin ayri compose dosyasi kullanimi:

```bash
docker compose -f docker/compose/prod.yml up -d --build
docker compose -f docker/compose/prod.yml down
```

## 12. Dockerfile komutlari (FROM, WORKDIR, RUN, CMD, vb.)

Dockerfile icinde kullanilan temel komutlar:

- `FROM`: Temel image secimi.
  Ornek: `FROM node:18-alpine`
- `WORKDIR`: Container icindeki calisma dizinini ayarlar.
  Ornek: `WORKDIR /app`
- `RUN`: Image build sirasinda komut calistirir (katman olusturur).
  Ornek: `RUN npm ci --only=production`
- `COPY`: Dosya/klasor kopyalar (host -> image).
  Ornek: `COPY package*.json ./`
- `ADD`: `COPY` gibi ama ek ozellikleri vardir (URL cekme, tar acma).
  Ornek: `ADD https://example.com/file.tar.gz /app/`
- `CMD`: Container calistiginda varsayilan komut.
  Ornek: `CMD ["node", "app.js"]`
- `ENTRYPOINT`: Container icin sabit calistirma komutu (CMD arguman olabilir).
  Ornek: `ENTRYPOINT ["node"]`
- `EXPOSE`: Container icindeki portu belgeler.
  Ornek: `EXPOSE 3001`
- `ENV`: Ortam degiskeni tanimlar.
  Ornek: `ENV NODE_ENV=production`
- `ARG`: Build sirasinda kullanilan degisken.
  Ornek: `ARG APP_VERSION`
- `USER`: Container icindeki kullaniciyi degistirir.
  Ornek: `USER node`
- `VOLUME`: Kalici veri bolgesi tanimlar.
  Ornek: `VOLUME /app/data`
- `LABEL`: Image meta verisi ekler.
  Ornek: `LABEL maintainer="yunuscaynak"`
- `HEALTHCHECK`: Container saglik kontrolu tanimlar.
  Ornek: `HEALTHCHECK CMD curl -f http://localhost:3001/ || exit 1`
- `STOPSIGNAL`: Container durdurma sinyalini ayarlar.
  Ornek: `STOPSIGNAL SIGTERM`
- `SHELL`: RUN komutlarinda kullanilacak kabugu ayarlar.
  Ornek: `SHELL ["/bin/sh", "-c"]`
- `ONBUILD`: Bu image baska image icin temel olursa calistirilacak komut.
  Ornek: `ONBUILD COPY . /app`

Notlar:
- `CMD` bir tane olmali, birden fazlasi varsa sonuncusu gecerli olur.
- `ENTRYPOINT` + `CMD` birlikte kullanilirsa, `CMD` arguman gibi davranir.

## 13. Docker Volumes (Kalici Veri Yonetimi)

Volume olusturma, listeleme, silme:

```bash
docker volume create my-data
docker volume ls
docker volume rm my-data
```

Named volumes vs bind mounts:
- Named volume: Docker tarafindan yonetilir, daha tasinabilir.
- Bind mount: Host klasorunu dogrudan baglar, gelistirmede kullanilir.

Ornek (named volume):

```bash
docker run -d --name db -v my-data:/var/lib/postgresql/data postgres:16
```

Ornek (bind mount):

```bash
docker run -d --name app -v ./data:/app/data my-app:latest
```

Not: Container silinse bile named volume icindeki veri kalir.

## 14. Docker Network

Network turleri:
- `bridge`: Varsayilan. Container'lar arasi iletisim icin.
- `host`: Host network'ini direkt kullanir.
- `none`: Network kapali.
- `overlay`: Swarm/Kubernetes benzeri ortamlarda.

Custom network:

```bash
docker network create my-net
docker network ls
docker network inspect my-net
```

Container'lari ayni network'te calistirma:

```bash
docker run -d --name app --network my-net my-app:latest
docker run -d --name api --network my-net my-api:latest
```

Not: Ayni custom network'te container isimleri DNS olarak calisir (app -> api).

## 15. Environment Variables (Ortam Degiskenleri)

Tek tek degisken gecmek:

```bash
docker run -e NODE_ENV=production -e PORT=3001 my-app:latest
```

.env dosyasi ile:

```bash
docker run --env-file .env my-app:latest
```

.env dosyasi ornegi:

```env
NODE_ENV=production
PORT=3001
DB_HOST=localhost
DB_USER=admin
```

Compose ile env_file:

```yaml
services:
  app:
    env_file:
      - .env
```

## 16. Docker Exec (Calisan Container'a Baglanma)

Container icine terminal:

```bash
docker exec -it docker-ornek sh
```

Komut calistirma:

```bash
docker exec -it docker-ornek ls -la
```

Debug icin kullanilir (loglar, konfig, dosyalar).

## 16.1 Docker Container Kopyalama (docker cp)

```bash
# Container'dan host'a dosya kopyala
docker cp docker-ornek:/app/log.txt ./log.txt

# Host'tan container'a dosya kopyala
docker cp ./config.json docker-ornek:/app/config.json
```

## 17. Multi-stage Build

Build ve run asamalarini ayirarak image boyutunu kucultur.

Ornek:

```dockerfile
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
EXPOSE 3001
CMD ["node", "dist/app.js"]
```

## 18. .dockerignore Dosyasi

Image icine kopyalanmamasini istedigin dosyalari belirtir.
Ornek:

```txt
node_modules
.git
.env
dist
```

Best practices:
- `node_modules` ve `.git` mutlaka haric tutulur.
- Build sonucu gelistirme dosyalarini ayiklar.

## 19. Docker Container Kaynak Limitleri

CPU ve memory limit:

```bash
docker run --cpus="1.5" --memory="512m" my-app:latest
```

## 20. Docker Prune (Temizlik Komutlari)

Kullanilmayan her seyi siler:

```bash
docker system prune
```

Sadece image temizligi:

```bash
docker image prune
```

Not: Disk alanini rahatlatir ama geri alinmaz.

## 21. Docker Inspect

Detaylari JSON olarak gor:

```bash
docker inspect docker-ornek
docker inspect yunuscaynak/docker-ornek:v2
```

Network ve volume bilgileri icin kullanilir.

## 22. Docker Stats

Calisan container'larin kaynak kullanimini canli gor:

```bash
docker stats
```

## 23. Health Checks

Dockerfile icinde:

```dockerfile
HEALTHCHECK CMD curl -f http://localhost:3001/ || exit 1
```

Compose icinde:

```yaml
services:
  app:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001/"]
      interval: 30s
      timeout: 5s
      retries: 3
```

## 24. Restart Policies

```bash
docker run --restart=always my-app:latest
```

Secenekler:
- `no` (varsayilan)
- `always`
- `on-failure`
- `unless-stopped`

Prod ortaminda genelde `unless-stopped` veya `always` tercih edilir.

## 25. Docker Registry

Alternatif registry'ler:
- Docker Hub
- GitHub Container Registry (GHCR)
- GitLab Registry
- Private registry

Local registry ornegi:

```bash
docker run -d -p 5000:5000 --name registry registry:2
docker tag my-app:latest localhost:5000/my-app:latest
docker push localhost:5000/my-app:latest
```

## 26. Security Best Practices

- Root yerine `USER node` gibi non-root kullan.
- Minimal base image (alpine, distroless).
- Secrets icin env yerine secret manager tercih et.
- Image scanning: `docker scout` veya registry taramalari.

## 27. Troubleshooting

Yaygin hatalar:
- Port cakismasi: `Bind for 0.0.0.0:PORT failed`
  Cozum: Portu degistir veya o portu kullanan container'i durdur.
- Permission hatalari: Volume mount izinlerini kontrol et.
- Container kapanmasi: `docker logs <name>` ile sebebini gor.
- Image bulunamiyor: `docker pull` veya dogru tag kullandigini kontrol et.

## 28. Docker Commit (Acil Durum)

Calisan container'dan yeni image olustur:

```bash
docker commit docker-ornek docker-ornek:backup
```

Not: Best practice degil, acil durumlarda gecici cozum.

## 29. Docker Export/Import

Container'i tar dosyasina aktar:

```bash
docker export docker-ornek > backup.tar
```

Tar'dan image olustur:

```bash
docker import backup.tar docker-ornek:imported
```

## 30. Makefile ile Proje Genel Kullanim

Bu projede uzun Docker komutlari yerine `make` hedefleri kullanilabilir.

Yardim:

```bash
make help
```

Dev:

```bash
make dev
make dev-build
make dev-down
make dev-logs
```

Prod:

```bash
make prod-up TAG=v2
make prod-down
make prod-logs
```

Image:

```bash
make image-build TAG=v2
make image-history TAG=v2
make image-inspect TAG=v2
```

Docker Hub:

```bash
make hub-push TAG=v2
make hub-pull TAG=v2
make hub-run TAG=v2
```

Container debug:

```bash
make status
make logs
make shell
make restart
```

## 31. Node Script Komutlari (Makefile)

`package.json` scriptlerini `make` ile de calistirabilirsin:

```bash
make npm-install
make npm-start
make npm-dev
make npm-test
```

Esdeger npm komutlari:

```bash
npm install
npm start
npm run dev
npm test
```
