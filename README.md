# Mongo Form App

Docker ile calisan basit bir `Node.js + Express + MongoDB` form uygulamasi.

## API

- `GET /` -> HTML form arayuzu
- `GET /api/health` -> servis ve Mongo baglanti durumu
- `GET /api/forms` -> kayitli formlari listeler
- `POST /api/forms` -> yeni form kaydi olusturur

## Proje Yapisi

- `app.js` -> Express API ve MongoDB baglantisi
- `public/index.html` -> form UI
- `docker/compose/dev.yml` -> development stack
- `docker/compose/prod.yml` -> production stack
- `docker/dev/Dockerfile` -> development image
- `docker/prod/Dockerfile` -> production image
- `Makefile` -> tek komutla calistirma/test hedefleri

## Ortam Degiskenleri

`.env.example` dosyasini kopyalayip `.env` olustur:

```bash
cp .env.example .env
```

Varsayilan degerler:

```env
PORT=3001
MONGO_URI=mongodb://localhost:27017/form_app_db
MONGO_DB_NAME=form_app_db
MONGO_COLLECTION=forms
```

Docker Compose icinde `MONGO_URI`, servis ismi kullanacak sekilde otomatik olarak `mongodb://mongo:27017/<MONGO_DB_NAME>` degerine cekilir.

## Lokal Calistirma

```bash
npm install
npm start
```

## Docker ile Calistirma

```bash
make dev
make prod
make stop
```

## Test Icin Ornek Istek

```bash
make test-post
```
