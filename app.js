require("dotenv").config();
const express = require("express");
const { MongoClient } = require("mongodb");

const PORT = Number(process.env.PORT || 3001);
const MONGO_URI =
  process.env.MONGO_URI || "mongodb://localhost:27017/form_app_db";
const DB_NAME = process.env.MONGO_DB_NAME || "form_app_db";
const COLLECTION_NAME = process.env.MONGO_COLLECTION || "forms";

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static("public"));

const mongoClient = new MongoClient(MONGO_URI);
let formCollection;

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

async function connectMongoWithRetry(maxRetries = 20, retryDelayMs = 3000) {
  for (let attempt = 1; attempt <= maxRetries; attempt += 1) {
    try {
      await mongoClient.connect();
      formCollection = mongoClient.db(DB_NAME).collection(COLLECTION_NAME);
      await formCollection.createIndex({ createdAt: -1 });
      console.log("MongoDB baglantisi hazir.");
      return;
    } catch (error) {
      console.error(
        `MongoDB baglanti denemesi ${attempt}/${maxRetries} basarisiz: ${error.message}`
      );
      if (attempt === maxRetries) {
        throw error;
      }
      await sleep(retryDelayMs);
    }
  }
}

app.get("/api/health", (_req, res) => {
  res.json({
    status: "ok",
    mongoConnected: Boolean(formCollection),
  });
});

app.get("/api/forms", async (req, res) => {
  try {
    if (!formCollection) {
      return res.status(503).json({
        message: "MongoDB baglantisi henuz hazir degil.",
      });
    }

    const limitParam = Number(req.query.limit || 20);
    const limit = Number.isFinite(limitParam)
      ? Math.min(Math.max(limitParam, 1), 100)
      : 20;

    const forms = await formCollection
      .find({})
      .sort({ createdAt: -1 })
      .limit(limit)
      .toArray();

    return res.json({
      count: forms.length,
      items: forms.map((form) => ({
        id: String(form._id),
        name: form.name,
        email: form.email,
        message: form.message,
        createdAt: form.createdAt,
      })),
    });
  } catch (error) {
    console.error("Formlar listelenemedi:", error);
    return res.status(500).json({
      message: "Formlar listelenirken beklenmeyen bir hata olustu.",
    });
  }
});

app.post("/api/forms", async (req, res) => {
  try {
    const name = String(req.body.name || "").trim();
    const email = String(req.body.email || "").trim();
    const message = String(req.body.message || "").trim();

    if (!name || !email || !message) {
      return res.status(400).json({
        message: "name, email ve message alanlari zorunludur.",
      });
    }

    if (!formCollection) {
      return res.status(503).json({
        message: "MongoDB baglantisi henuz hazir degil.",
      });
    }

    const result = await formCollection.insertOne({
      name,
      email,
      message,
      createdAt: new Date(),
    });

    return res.status(201).json({
      message: "Form kaydedildi.",
      id: result.insertedId,
    });
  } catch (error) {
    console.error("Form kaydedilemedi:", error);
    return res.status(500).json({
      message: "Form kaydi sirasinda beklenmeyen bir hata olustu.",
    });
  }
});

async function start() {
  try {
    await connectMongoWithRetry();
    app.listen(PORT, () => {
      console.log(`Server ${PORT} portunda calisiyor`);
    });
  } catch (error) {
    console.error("Uygulama baslatilamadi:", error);
    process.exit(1);
  }
}

start();
