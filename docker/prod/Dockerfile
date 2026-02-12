# 1️⃣ Temel imaj
FROM node:18-alpine

# 2️⃣ Container içindeki çalışma klasörü
WORKDIR /app

# 3️⃣ Dosyaları container içine kopyala
# 3.1️⃣ önce bağımlılıklar (cache için)
COPY package*.json ./
RUN npm ci --only=production

# 3.2️⃣ sonra kod
COPY . .

# 4️⃣ Port
EXPOSE 3001

# 5️⃣ Uygulama başlatma komutu
CMD ["node", "app.js"]

