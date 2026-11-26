'use strict';
// Salgsdemo – liten statisk webside uten npm-avhengigheter.
// Versjon settes ved bygging (APP_VERSION / BUILD_DATE) og flettes inn i HTML-en.
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');

const PORT = Number(process.env.PORT || 3000);
const VERSION = process.env.APP_VERSION || 'dev';
const BUILD_DATE = process.env.BUILD_DATE || '';
const COMMIT = (process.env.GIT_COMMIT || '').slice(0, 7);
const REPO_URL = process.env.REPO_URL || 'https://github.com/TommyRasmussenUpheads/salgsdemo';

const esc = (s) => String(s).replace(/[&<>"']/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

const template = fs.readFileSync(path.join(__dirname, 'public', 'index.html'), 'utf8');
const page = template
  .replaceAll('{{VERSION}}', esc(VERSION))
  .replaceAll('{{BUILD_DATE}}', esc(BUILD_DATE))
  .replaceAll('{{COMMIT}}', esc(COMMIT))
  .replaceAll('{{REPO_URL}}', esc(REPO_URL));

const send = (res, code, type, body) => {
  res.writeHead(code, {
    'Content-Type': type,
    'Cache-Control': 'no-cache',
    'X-Content-Type-Options': 'nosniff',
    'Referrer-Policy': 'strict-origin-when-cross-origin',
  });
  res.end(body);
};

http
  .createServer((req, res) => {
    const url = new URL(req.url, 'http://localhost');
    if (req.method !== 'GET' && req.method !== 'HEAD') return send(res, 405, 'text/plain; charset=utf-8', 'Method not allowed');
    switch (url.pathname) {
      case '/':
      case '/index.html':
        return send(res, 200, 'text/html; charset=utf-8', page);
      case '/version.json':
        return send(res, 200, 'application/json', JSON.stringify({ version: VERSION, build_date: BUILD_DATE, commit: COMMIT, repo: REPO_URL }));
      case '/healthz':
        return send(res, 200, 'text/plain; charset=utf-8', 'ok');
      default:
        return send(res, 404, 'text/plain; charset=utf-8', 'Ikke funnet');
    }
  })
  .listen(PORT, () => console.log(`Salgsdemo ${VERSION} lytter på ${PORT}`));
