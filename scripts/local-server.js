const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  // Serve files from parent directory (shell-apps-repo root)
  const filePath = path.join(__dirname, '..', req.url);
  
  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('File not found');
      return;
    }
    
    // Set content type based on file extension
    const ext = path.extname(filePath);
    let contentType = 'text/plain';
    if (ext === '.yml' || ext === '.yaml') contentType = 'text/yaml';
    if (ext === '.svg') contentType = 'image/svg+xml';
    if (ext === '.png') contentType = 'image/png';
    
    res.setHeader('Content-Type', contentType);
    res.writeHead(200);
    res.end(data);
  });
});

server.listen(8080, () => {
  console.log('Local development server running on http://localhost:8080');
  console.log('Serving files from shell-apps-repo directory');
  console.log('Press Ctrl+C to stop');
});