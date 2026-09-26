/**
 * MDEsq - Local Development & Testing Server
 * Zero-dependency native Node.js HTTP server supporting ES modules and MIME types.
 */

import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const PORT = process.env.PORT || 3080;

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon'
};

const server = http.createServer((req, res) => {
  let reqPath = req.url.split('?')[0];
  if (reqPath === '/') reqPath = '/index.html';

  if (req.method === 'OPTIONS') {
    res.writeHead(204, {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization, x-goog-api-key'
    });
    res.end();
    return;
  }

  // Handle local /api/chat endpoint proxy
  if (reqPath === '/api/chat' && req.method === 'POST') {
    let bodyData = '';
    req.on('data', chunk => { bodyData += chunk; });
    req.on('end', async () => {
      try {
        const body = JSON.parse(bodyData || '{}');
        const { prompt, jurisdiction } = body;

        const apiKey = process.env.GEMINI_API_KEY || req.headers['x-goog-api-key'] || '';
        if (!apiKey) {
          res.writeHead(200, {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          });
          res.end(JSON.stringify({
            response: `⚖️ [MDEsq AI Local Offline Mode]\n\nJurisdiction: ${jurisdiction || 'WA'}\nQuery: "${prompt}"\n\nTo enable live generative responses locally, launch server with GEMINI_API_KEY=your_key or configure your key in Settings. For production, Cloudflare Pages Worker handles /api/chat automatically with zero client-side key exposure.`
          }));
          return;
        }

        const stateContext = jurisdiction || 'WA';
        const systemPrompt = `You are MDEsq, an elite physician-legal advocate and medicolegal strategist for licensed physicians and surgeons.
Your active jurisdiction is ${stateContext} (Washington State: RCW 18.71, RCW 7.70, RCW 49.62, WAC 246-919, WMC rules).
You provide sharp, legally grounded, practical advice regarding hospital contract negotiations, Fair Market Value (FMV), Stark Law, non-competes, medical malpractice standard of care defense, and medical board investigations.
Always maintain a direct, professional, protective tone for the physician.
Include statutory citations (RCW/WAC/Stark) where relevant. Include a brief educational disclaimer.`;

        const geminiEndpoint = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`;
        const geminiPayload = {
          contents: [{ role: 'user', parts: [{ text: `${systemPrompt}\n\nUser Question:\n${prompt}` }] }],
          generationConfig: { temperature: 0.2, maxOutputTokens: 1000 }
        };

        const upstream = await fetch(geminiEndpoint, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify(geminiPayload)
        });

        const data = await upstream.json();
        if (!upstream.ok) {
          res.writeHead(upstream.status, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
          res.end(JSON.stringify({ error: `Upstream Gemini API error: ${upstream.status}`, details: data }));
          return;
        }

        const replyText = data.candidates?.[0]?.content?.parts?.[0]?.text || 'No response generated.';
        res.writeHead(200, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
        res.end(JSON.stringify({ response: replyText }));
      } catch (err) {
        res.writeHead(500, { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' });
        res.end(JSON.stringify({ error: err.message }));
      }
    });
    return;
  }

  const filePath = path.join(__dirname, reqPath);
  const ext = path.extname(filePath).toLowerCase();
  const contentType = MIME_TYPES[ext] || 'application/octet-stream';

  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('404 Not Found');
      } else {
        res.writeHead(500, { 'Content-Type': 'text/plain' });
        res.end(`500 Internal Server Error: ${err.code}`);
      }
    } else {
      res.writeHead(200, {
        'Content-Type': contentType,
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Access-Control-Allow-Origin': '*'
      });
      res.end(content, 'utf-8');
    }
  });
});

server.listen(PORT, '127.0.0.1', () => {
  console.log(`⚖️ MDEsq local server active at: http://localhost:${PORT}`);
});
