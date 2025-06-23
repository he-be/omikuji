# Cloudflare Workers デプロイメントガイド

## 概要

このプロジェクトは Cloudflare Workers にデプロイできるように設定されています。Express アプリケーションを Workers 対応版に変換し、GitHub Actions で自動デプロイを行います。

## 必要な設定

### 1. Cloudflare API トークンの取得

1. [Cloudflare Dashboard](https://dash.cloudflare.com/) にログイン
2. 右上のプロフィール → 「My Profile」
3. 「API Tokens」タブ
4. 「Create Token」をクリック
5. 「Custom token」を選択
6. 以下の権限を設定：
   - **Zone**: `Zone:Read` (すべてのゾーン)
   - **Account**: `Cloudflare Workers:Edit` (対象アカウント)
   - **Zone Resources**: `Include - All zones`

### 2. Account ID の取得

1. Cloudflare Dashboard の右サイドバーに表示される「Account ID」をコピー

### 3. GitHub Secrets の設定

リポジトリの Settings → Secrets and variables → Actions で以下を追加：

```
CLOUDFLARE_API_TOKEN=your_api_token_here
CLOUDFLARE_ACCOUNT_ID=your_account_id_here
```

## デプロイメントフロー

### 自動デプロイ（推奨）

main ブランチにプッシュすると自動的にデプロイされます：

```bash
git push origin main
```

### 手動デプロイ

ローカルから直接デプロイすることも可能：

```bash
# ローカル開発
npm run dev:worker

# ビルド
npm run build:worker

# デプロイ（API トークンが必要）
npm run deploy
```

**注意**: Wrangler v3 以降では `wrangler publish` が `wrangler deploy` に変更されました。

## プロジェクト構造

```
src/
├── index.ts           # Express版（開発・テスト用）
├── worker.ts          # Cloudflare Workers版
└── __tests__/
    ├── index.test.ts  # Express版テスト
    └── worker.test.ts # Workers版テスト
```

## 主な違い

### Express版 (src/index.ts)
- Node.js環境で動作
- Express フレームワーク使用
- 開発・テスト用

### Workers版 (src/worker.ts)
- Cloudflare Workers環境で動作
- Web標準API使用
- 本番デプロイ用

## API エンドポイント

デプロイ後は以下のエンドポイントが利用可能：

- `GET /` - おみくじページ（HTML）
- `GET /api/omikuji` - おみくじAPI（JSON）

## 設定ファイル

### wrangler.toml
```toml
name = "omikuji"
main = "dist/worker.js"
compatibility_date = "2024-01-01"

[env.production]
name = "omikuji"

[build]
command = "npm run build:worker"
```

## CI/CD パイプライン

### ステージ
1. **build-and-test**: テスト・カバレッジ・Workers ビルド
2. **deploy**: main ブランチのみ Cloudflare Workers にデプロイ

### 特徴
- Self-hosted runner 使用
- テストカバレッジ 80% 以上
- 自動デプロイ（main ブランチ）
- PR でのカバレッジレポート

## トラブルシューティング

### デプロイエラー

1. **API トークン関連**
   ```
   Error: Authentication error
   ```
   → GitHub Secrets の `CLOUDFLARE_API_TOKEN` を確認

2. **Account ID 関連**
   ```
   Error: Account not found
   ```
   → GitHub Secrets の `CLOUDFLARE_ACCOUNT_ID` を確認

3. **ビルドエラー**
   ```
   Error: Build failed
   ```
   → `npm run build:worker` をローカルで実行して確認

### ローカル開発

```bash
# Workers 版のローカル開発
npm run dev:worker

# Express 版のローカル開発
npm run dev
```

## パフォーマンス

### Cloudflare Workers の利点
- グローバルエッジデプロイ
- 高速なコールドスタート
- 無料枠：1日 100,000 リクエスト
- 自動スケーリング

### 制限事項
- CPU 時間：10ms（無料）／50ms（有料）
- メモリ：128MB
- Node.js 非対応（Web標準APIのみ）