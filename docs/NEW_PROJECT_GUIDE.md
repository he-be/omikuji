# 新規プロジェクト効率化ガイド

## 概要

このガイドは、Claude Code + GitHub + Cloudflare Workers を組み合わせた個人開発の効率化実験の成果をまとめたものです。新しいプロジェクトで即座に高効率開発を始められます。

## 🚀 クイックスタート（1分）

### 方法1: 自動セットアップスクリプト

```bash
# このリポジトリをクローン
git clone https://github.com/he-be/omikuji.git
cd omikuji

# 新プロジェクト作成
./templates/project-setup-optimized.sh my-new-project
cd my-new-project

# 依存関係インストール
npm install

# 初期コミット
git add . && git commit -m "Initial setup with optimization"
```

### 方法2: Claude Code コマンド

Claude Code で以下を実行：

```
/setup-fullstack my-new-project
```

## 📋 セットアップ完了内容

### ✅ 自動設定される要素

1. **プロジェクト構造**
   ```
   my-new-project/
   ├── src/
   │   ├── index.ts          # Express版（開発用）
   │   ├── worker.ts         # Workers版（本番用）
   │   └── __tests__/        # テストファイル
   ├── .claude/             # カスタムコマンド
   ├── .github/workflows/   # CI/CD設定
   ├── templates/           # 再利用テンプレート
   └── docs/               # ドキュメント
   ```

2. **開発環境**
   - TypeScript strict mode + 厳格設定
   - Vitest テストフレームワーク
   - ESLint + Prettier 統合
   - 80%+ カバレッジ強制

3. **CI/CD パイプライン**
   - GitHub Actions self-hosted runner 対応
   - 段階的品質チェック
   - 自動カバレッジレポート
   - Cloudflare Workers 自動デプロイ

4. **Claude Code 最適化**
   - カスタムコマンド（`/check-ci`, `/sync-main`等）
   - 個人開発ルール（Claude.md）
   - 効率化プロンプトテンプレート

## 🔧 初期設定手順

### 1. GitHub リポジトリ作成

```bash
# GitHub CLI でリポジトリ作成
gh repo create my-new-project --public --source=. --remote=origin --push
```

### 2. Cloudflare Workers 設定

1. **API トークン取得**
   - [Cloudflare Dashboard](https://dash.cloudflare.com/) → My Profile → API Tokens
   - Create Token → Custom token
   - 権限: `Zone:Read`, `Cloudflare Workers:Edit`

2. **GitHub Secrets 設定**
   ```bash
   gh secret set CLOUDFLARE_API_TOKEN
   gh secret set CLOUDFLARE_ACCOUNT_ID
   ```

### 3. Self-hosted Runner（推奨）

```bash
# GitHub リポジトリの Settings → Actions → Runners
# Add runner の手順に従って自宅サーバーにセットアップ
```

## 💡 開発フロー

### 日常的な開発

1. **Issue 作成 → ブランチ**
   ```bash
   gh issue create --title "新機能" --body "詳細"
   git checkout -b feature/new-feature
   ```

2. **実装 + テスト**
   ```bash
   npm run dev          # 開発サーバー起動
   npm run test:watch   # テスト監視
   ```

3. **PR 作成 → 自動デプロイ**
   ```bash
   git commit -m "feat: 新機能追加"
   gh pr create --title "新機能追加" --body "説明"
   ```

### Claude Code 効率化コマンド

- **`/check-ci`** - CI失敗時の自動修正
- **`/sync-main`** - main ブランチ同期
- **`/deploy-test`** - デプロイテスト
- **`/fix-coverage`** - カバレッジ改善
- **`/setup-cloudflare`** - Workers設定追加

## 📊 品質基準（自動強制）

### コード品質
- ✅ TypeScript strict mode
- ✅ ESLint エラーゼロ
- ✅ Prettier フォーマット統一
- ✅ テストカバレッジ 80%+

### CI/CD 要件
- ✅ 全品質チェック通過
- ✅ ビルド成功
- ✅ デプロイ後ヘルスチェック
- ✅ PR カバレッジレポート

## 🎯 パフォーマンス目標

### 実証済み数値
- **CI パイプライン**: 2-3分（self-hosted効果）
- **テスト実行**: 10-30秒
- **ビルド**: 30秒-1分
- **デプロイ**: 30-60秒
- **グローバル配信**: 即座

### 開発効率向上
- **初期セットアップ**: 10分 → 1分
- **機能追加**: 半日 → 1-2時間
- **デプロイ**: 手動30分 → 自動3分

## 💰 コスト効率

### 月額費用
- **GitHub Actions**: $0（self-hosted）
- **Cloudflare Workers**: $0-5（無料枠大）
- **合計**: ほぼ無料

### ROI
- **開発効率**: 3-5倍向上
- **品質向上**: 自動化による安定性
- **運用負荷**: ほぼゼロ（全自動）

## 🛠 カスタマイズ

### プロジェクト特有の要件

1. **フレームワーク追加**
   ```bash
   # React追加例
   npm install react react-dom @types/react @types/react-dom
   # package.json の scripts 更新
   # tsconfig.json に JSX設定追加
   ```

2. **データベース統合**
   ```bash
   # Cloudflare D1追加例
   npm install @cloudflare/workers-types
   # wrangler.toml にD1設定追加
   ```

3. **認証機能**
   ```bash
   # JWT認証例
   npm install jsonwebtoken @types/jsonwebtoken
   # 認証ミドルウェア実装
   ```

### CI/CD カスタマイズ

```yaml
# .github/workflows/ci.yml に追加例
- name: Run E2E tests
  run: npm run test:e2e

- name: Deploy to staging
  if: github.ref == 'refs/heads/develop'
  run: npm run deploy:staging
```

## 🔍 トラブルシューティング

### よくある問題

1. **CI 失敗時**
   ```
   Claude Code: /check-ci
   ```

2. **カバレッジ不足**
   ```
   Claude Code: /fix-coverage
   ```

3. **デプロイエラー**
   ```bash
   # Cloudflare認証確認
   npx wrangler whoami
   
   # ローカルテスト
   npm run dev:worker
   ```

### 個人開発特有の対応

- **Self-hosted runner 不調**: GitHub-hosted に一時切替
- **Cloudflare制限**: 無料枠監視、必要に応じて有料プラン
- **テスト重すぎ**: 並列化、モック活用

## 📚 参考リソース

### ドキュメント
- `Claude.md` - AI開発ルール
- `docs/CLOUDFLARE_DEPLOYMENT.md` - デプロイガイド
- `docs/CLAUDE_CODE_WORKFLOW.md` - 効率化パターン

### テンプレート
- `templates/project-setup-optimized.sh` - 自動セットアップ
- `templates/github-actions-optimized.yml` - CI/CD テンプレート
- `.claude/commands.md` - カスタムコマンド

### 実例
- このリポジトリ自体が実証例
- デプロイ済み: https://omikuji.masahiro-hibi.workers.dev/

## 🎉 次のステップ

1. **第一号プロジェクト作成**
   ```bash
   ./templates/project-setup-optimized.sh my-first-optimized-project
   ```

2. **Claude Code で開発**
   ```
   新しい機能を実装してください：
   - 認証システム
   - API エンドポイント追加
   - フロントエンド統合
   ```

3. **効率化の実感**
   - コミット → 自動デプロイ → 世界配信
   - 高品質コード自動生成
   - 運用負荷ゼロ

**Happy Coding! 🚀**