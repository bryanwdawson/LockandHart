// Minimal local HTTP server for previewing the Japan Explorer.
// The explorer loads days.json / pins.json with fetch(), which browsers
// block over file:// — so it must be served over http. This does that.
const http = require('http');
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, 'public', 'private', 'japan');
const port = 8123;

const types = {
  '.html': 'text/html; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png': 'image/png',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.mp4': 'video/mp4',
  '.webp': 'image/webp'
};

http.createServer((req, res) => {
  let urlPath = decodeURIComponent(req.url.split('?')[0]);
  if (urlPath === '/') urlPath = '/index.html';
  const filePath = path.normalize(path.join(root, urlPath));
  if (!filePath.startsWith(root)) {
    res.writeHead(403);
    res.end('Forbidden');
    return;
  }
  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(404);
      res.end('Not found: ' + urlPath);
      return;
    }
    const ext = path.extname(filePath).toLowerCase();
    res.writeHead(200, { 'Content-Type': types[ext] || 'application/octet-stream', 'Cache-Control': 'no-cache, no-store, must-revalidate' });
    res.end(data);
  });
}).listen(port, () => {
  const url = 'http://localhost:' + port;
  console.log('');
  console.log('  Japan Explorer preview running at ' + url);
  console.log('  Opening your browser...');
  console.log('  Keep this window open while viewing. Close it to stop.');
  console.log('');
  require('child_process').exec('start "" "' + url + '"');
});
