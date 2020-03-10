const http = require('http');
const server = http.createServer((req, res) => {
  setTimeout(() => {
    res.writeHead(200);
    res.end(`Path: ${req.url}`);
  }, 1000);
});
server.listen(3000);
