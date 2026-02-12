require("dotenv").config();
const http = require("http");

const PORT = Number(process.env.PORT || 3001);

http
  .createServer((req, res) => {
    res.end("Docker calisiyor v2 versiyonu ayakta)");
  })
  .listen(PORT);

console.log(`Server ${PORT} portunda calisiyor`);
