/**
 * MDEsq - Cloudflare Unified Worker & Static Asset Handler
 * Handles /api/chat serverless edge proxy to Google Gemini API
 * and proxies all static assets (HTML/JS/CSS/Data) via env.ASSETS.
 */

export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);

    // 1. CORS Preflight
    if (request.method === "OPTIONS") {
      return new Response(null, {
        status: 204,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
          "Access-Control-Allow-Headers": "Content-Type, Authorization, x-goog-api-key"
        }
      });
    }

    // 2. Serverless Edge API Endpoint for AI Copilot
    if (url.pathname === "/api/chat" && request.method === "POST") {
      try {
        const body = await request.json();
        const { prompt, jurisdiction } = body;

        if (!prompt) {
          return new Response(JSON.stringify({ error: "Missing prompt parameter" }), {
            status: 400,
            headers: {
              "Content-Type": "application/json",
              "Access-Control-Allow-Origin": "*"
            }
          });
        }

        const apiKey = env.GEMINI_API_KEY;
        if (!apiKey) {
          return new Response(JSON.stringify({
            error: "Serverless GEMINI_API_KEY not configured in Cloudflare environment secrets.",
            isMock: true
          }), {
            status: 500,
            headers: {
              "Content-Type": "application/json",
              "Access-Control-Allow-Origin": "*"
            }
          });
        }

        const stateContext = jurisdiction || 'WA';
        const systemPrompt = `You are MDEsq, an elite physician-legal advocate and medicolegal strategist for licensed physicians and surgeons.
Your active jurisdiction is ${stateContext} (Washington State: RCW 18.71, RCW 7.70, RCW 49.62, WAC 246-919, WMC rules).
You provide sharp, legally grounded, practical advice regarding hospital contract negotiations, Fair Market Value (FMV), Stark Law, non-competes, medical malpractice standard of care defense, and medical board investigations.
Always maintain a direct, professional, protective tone for the physician.
Include statutory citations (RCW/WAC/Stark) where relevant. Include a brief educational disclaimer.`;

        const geminiEndpoint = `https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent?key=${apiKey}`;

        const geminiPayload = {
          contents: [
            {
              role: "user",
              parts: [
                { text: `${systemPrompt}\n\nUser Question:\n${prompt}` }
              ]
            }
          ],
          generationConfig: {
            temperature: 0.2,
            maxOutputTokens: 1000
          }
        };

        const upstreamResponse = await fetch(geminiEndpoint, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(geminiPayload)
        });

        if (!upstreamResponse.ok) {
          const errText = await upstreamResponse.text();
          return new Response(JSON.stringify({ error: `Upstream Gemini API error: ${upstreamResponse.status}`, details: errText }), {
            status: upstreamResponse.status,
            headers: {
              "Content-Type": "application/json",
              "Access-Control-Allow-Origin": "*"
            }
          });
        }

        const data = await upstreamResponse.json();
        const replyText = data.candidates?.[0]?.content?.parts?.[0]?.text || "No response generated.";

        return new Response(JSON.stringify({ response: replyText }), {
          status: 200,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
          }
        });

      } catch (error) {
        return new Response(JSON.stringify({ error: error.message }), {
          status: 500,
          headers: {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
          }
        });
      }
    }

    // 3. Serve Static Assets (HTML, CSS, JS, etc.)
    if (env.ASSETS && typeof env.ASSETS.fetch === 'function') {
      return env.ASSETS.fetch(request);
    }

    return new Response("Not found", { status: 404 });
  }
};
