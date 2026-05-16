// Local HTTP server for previewing the Japan Explorer (v1 and v2).
// Serves /public/private/ as root, so both /japan/ and /japan-v2/ are reachable,
// and v2's `fetch('../japan/pins.json')` resolves correctly.
// Auto-picks an open port if the default is already in use.

const http = require('http');
const fs = require('fs');
const path = require('path');
const net = require('net');

const root = path.join(__dirname, 'public', 'private');
const preferredPort = 8123;
const openPath = '/japan-v2/'; // v2 is the default; switch to '/japan/' if you want v1.

const types = {
  '.html': 'text/html; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.js':   'text/javascript; charset=utf-8',
  '.css':  'text/css; charset=utf-8',
  '.jpg':  'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.png':  'image/png',
  '.gif':  'image/gif',
  '.svg':  'image/svg+xml',
  '.mp4':  'video/mp4',
  '.webp': 'image/webp',
};

function isFree(port) {
  return new Promise((resolve) => {
    const tester = net.createServer()
      .once('error', () => resolve(false))
      .once('listening', () => tester.close(() => resolve(true)))
      .listen(port, '127.0.0.1');
  });
}

async function pickPort() {
  for (let p = preferredPort; p < preferredPort + 20; p++) {
    if (await isFree(p)) return p;
  }
  throw new Error('No free port found in range');
}

(async () => {
  let port;
  try {
    port = await pickPort();
  } catch (e) {
    console.error('Could not find a free port. Reboot or check for stuck processes.');
    process.exit(1);
  }

  if (port !== preferredPort) {
    console.log('');
    console.log('  Port ' + preferredPort + ' is in use (another preview likely still running).');
    console.log('  Falling back to port ' + port + '.');
  }

  http.createServer((req, res) => {
    let urlPath = decodeURIComponent(req.url.split('?')[0]);
    if (urlPath === '/') urlPath = openPath;
    if (urlPath.endsWith('/')) urlPath += 'index.html';
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
      res.writeHead(200, {
        'Content-Type': types[ext] || 'application/octet-stream',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
      });
      res.end(data);
    });
  }).listen(port, () => {
    const base = 'http://localhost:' + port;
    console.log('');
    console.log('  Japan Explorer preview running at ' + base);
    console.log('    v2 (new): ' + base + '/japan-v2/');
    console.log('    v1 (old): ' + base + '/japan/');
    console.log('');
    console.log('  Keep this window open while viewing. Close it to stop.');
    console.log('');
    require('child_process').exec('start "" "' + base + openPath + '"');
  });
})();
