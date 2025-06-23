import express from 'express';
import path from 'path';

export const app = express();
const port = process.env.PORT || 3000;

app.use(express.static('public'));

export const omikujiResults = ['大凶', '凶', '小吉', '吉', '大吉'];

export function getRandomOmikuji(): string {
  const randomIndex = Math.floor(Math.random() * omikujiResults.length);
  return omikujiResults[randomIndex];
}

app.get('/', (req, res) => {
  const result = getRandomOmikuji();
  const html = `
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
  res.send(html);
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`おみくじアプリが http://localhost:${port} で起動しました`);
  });
}