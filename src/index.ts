// Cloudflare Workers対応版のおみくじアプリ

export const omikujiResults = ['大凶', '凶', '小吉', '吉', '大吉'];

export function getRandomOmikuji(): string {
  const randomIndex = Math.floor(Math.random() * omikujiResults.length);
  return omikujiResults[randomIndex];
}

function generateHTML(result: string): string {
  return `
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>おみくじ</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .omikuji-container {
            text-align: center;
            background: white;
            padding: 50px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            margin-bottom: 30px;
        }
        .result {
            font-size: 48px;
            font-weight: bold;
            color: #d4af37;
            margin: 30px 0;
            padding: 20px;
            border: 3px solid #d4af37;
            border-radius: 10px;
        }
        .reload-button {
            background-color: #4CAF50;
            color: white;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
            margin-top: 20px;
            display: inline-block;
        }
        .reload-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <div class="omikuji-container">
        <h1>おみくじ</h1>
        <div class="result">${result}</div>
        <a href="/" class="reload-button">もう一度引く</a>
    </div>
</body>
</html>
  `;
}

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    // ルートパスの処理
    if (url.pathname === '/') {
      const result = getRandomOmikuji();
      const html = generateHTML(result);

      return new Response(html, {
        headers: {
          'Content-Type': 'text/html; charset=utf-8',
          'Cache-Control': 'no-cache',
        },
      });
    }

    // APIエンドポイント（JSON）
    if (url.pathname === '/api/omikuji') {
      const result = getRandomOmikuji();

      return new Response(JSON.stringify({ result }), {
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      });
    }

    // 404 Not Found
    return new Response('Not Found', { status: 404 });
  },
};
