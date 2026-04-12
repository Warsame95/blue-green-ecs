from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse
import os, hashlib, time
from .ddb import put_mapping, get_mapping

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def home():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>URL Shortener</title>
        <style>
            body {
                margin: 0;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                background-color: #3b1e35;
                font-family: Arial, sans-serif;
                color: #f8fafc;
            }

            .card {
                width: 100%;
                max-width: 520px;
                padding: 2rem;
                border-radius: 12px;
                background-color: #334155;
                box-sizing: border-box;
            }

            h1 {
                margin-top: 0;
                margin-bottom: 1rem;
            }

            form {
                display: flex;
                gap: 0.75rem;
            }

            input {
                flex: 1;
                padding: 0.75rem;
                border: none;
                border-radius: 8px;
                font-size: 1rem;
            }

            button {
                padding: 0.75rem 1rem;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: bold;
            }

            .result-box {
                margin-top: 1rem;
                padding: 1rem;
                border-radius: 8px;
                background-color: #0f172a;
                border: 1px solid #475569;
                display: none;
            }

            .result-label {
                margin: 0 0 0.5rem 0;
                font-size: 0.9rem;
                color: #cbd5e1;
            }

            #result {
                word-break: break-all;
            }

            #result a {
                color: #93c5fd;
                text-decoration: none;
            }

            .error {
                color: #fca5a5;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>URL Shortener</h1>

            <form id="shorten-form">
                <input id="url" type="url" placeholder="https://example.com" required />
                <button type="submit">Shorten</button>
            </form>

            <div class="result-box" id="result-box">
                <p class="result-label">Shortened URL</p>
                <div id="result"></div>
            </div>
        </div>

        <script>
            const form = document.getElementById("shorten-form");
            const urlInput = document.getElementById("url");
            const resultBox = document.getElementById("result-box");
            const result = document.getElementById("result");

            form.addEventListener("submit", async function (event) {
                event.preventDefault();

                resultBox.style.display = "none";
                result.innerHTML = "";

                try {
                    const response = await fetch("/shorten", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json"
                        },
                        body: JSON.stringify({
                            url: urlInput.value
                        })
                    });

                    const data = await response.json();

                    if (!response.ok) {
                        result.innerHTML = '<span class="error">' + (data.detail || "Request failed") + '</span>';
                        resultBox.style.display = "block";
                        return;
                    }

                    const shortUrl = window.location.origin + "/" + data.short;

                    result.innerHTML = '<a href="' + shortUrl + '" target="_blank">' + shortUrl + '</a>';
                    resultBox.style.display = "block";
                } catch (error) {
                    result.innerHTML = '<span class="error">Request failed</span>';
                    resultBox.style.display = "block";
                }
            });
        </script>
    </body>
    </html>
    """

@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}

@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")
    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}

@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    return RedirectResponse(item["url"])
