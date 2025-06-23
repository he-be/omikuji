# Omikuji - Personal Development Optimization Experiment

Claude Code + GitHub + Cloudflare Workers を組み合わせた個人開発効率化の実験プロジェクト

## 🎯 プロジェクトの目的

このプロジェクトは **個人開発の定番要素を効率化する実験** として作られました：

- **Claude Code**: AI による高速コード生成・修正
- **GitHub Actions**: Self-hosted runner による高速 CI/CD  
- **Cloudflare Workers**: 無料・高速なグローバル配信

## 🚀 デモ

- **本番サイト**: https://omikuji.masahiro-hibi.workers.dev/
- **API**: https://omikuji.masahiro-hibi.workers.dev/api/omikuji

## 📊 実証された効率化

### パフォーマンス
- CI実行時間: 2-3分（self-hosted効果）
- テストカバレッジ: 92.59%（自動生成）
- デプロイ時間: 1分未満
- 月額費用: ほぼ$0

## 🛠 技術スタック

### 開発環境
- **言語**: TypeScript（strict mode）
- **フレームワーク**: Express.js
- **テスト**: Vitest + Supertest
- **品質**: ESLint + Prettier

### 本番環境  
- **ランタイム**: Cloudflare Workers
- **配信**: グローバルエッジネットワーク
- **API**: Web標準 API

### CI/CD
- **実行環境**: GitHub Actions self-hosted runner
- **カバレッジ**: 自動PR報告
- **デプロイ**: 完全自動化

## 🎨 効率化の仕組み

### 1. Claude Code 最適化
```bash
# カスタムコマンドで即座に実行
/check-ci        # CI確認・修正
/sync-main       # ブランチ同期  
/deploy-test     # デプロイテスト
/setup-cloudflare # Workers設定
```

### 2. 完全自動化フロー
```
Issue作成 → 実装 → テスト → PR → 自動デプロイ → 配信
```

### 3. 品質保証
- テストカバレッジ 80%+ 強制
- TypeScript strict mode
- 全CI段階の自動チェック

## 📁 プロジェクト構造

```
src/
├── index.ts           # Express版（開発・テスト用）
├── worker.ts          # Workers版（本番用）
└── __tests__/         # 包括的テスト

.claude/               # カスタムコマンド
├── commands.md        # 効率化コマンド定義
└── prompt-templates.md # 再利用プロンプト

.github/workflows/     # 最適化CI/CD
templates/             # 新規プロジェクト用テンプレート
docs/                  # 詳細ドキュメント
```

## 🚀 新規プロジェクトで活用

### 重要：omikuji の役割

**omikuji = 効率化テンプレート集（母艦）**
- 新しいプロジェクト作成用のテンプレートを提供
- 効率化ノウハウを蓄積

**新しいプロジェクト = omikuji から生成される独立したアプリ**
- omikuji とは完全に別のプロジェクト
- 独自の Git リポジトリ、独自のデプロイ先

### フォルダ構造例
```
/your-workspace/
├── omikuji/                   ← この効率化テンプレート集
├── my-blog-app/              ← omikuji から生成した独立プロジェクト
├── my-portfolio/             ← omikuji から生成した独立プロジェクト
└── my-saas-app/              ← omikuji から生成した独立プロジェクト
```

### クイックスタート

```bash
# 1. omikuji テンプレート集をクローン
git clone https://github.com/he-be/omikuji.git

# 2. プロジェクト作成場所に移動（omikuji の外）
cd /your-workspace/

# 3. テンプレートから新しい独立プロジェクトを生成
./omikuji/templates/project-setup-optimized.sh my-awesome-app

# 4. 生成されたプロジェクトに移動
cd my-awesome-app

# 5. 依存関係インストール
npm install

# 6. 独立したGitリポジトリとしてGitHubにプッシュ
gh repo create my-awesome-app --public --source=. --push
```

### 結果
- ✅ `my-awesome-app` という独立したプロジェクトが完成
- ✅ 効率化設定がすべて適用済み
- ✅ CI/CD、Cloudflare Workers デプロイ設定済み
- ✅ Claude Code カスタムコマンド使用可能

### 生成されたプロジェクトでの Claude Code 効率化

新しいプロジェクト（例：`my-awesome-app`）でも omikuji の効率化機能がそのまま使えます：

```bash
cd my-awesome-app

# Claude Code で以下のコマンドが使用可能
/check-ci        # CI確認・修正
/sync-main       # ブランチ同期  
/deploy-test     # デプロイテスト
/fix-coverage    # カバレッジ改善
```

機能追加例：
```
認証システムを実装してください：
- JWT トークン認証
- ログイン・ログアウト機能
- 80%+ テストカバレッジ達成
- 全テスト通過後に自動デプロイ
```

## 📚 ドキュメント

### 基本ガイド
- [新規プロジェクトガイド](docs/NEW_PROJECT_GUIDE.md) - 効率化されたセットアップ手順
- [Claude Code ワークフロー](docs/CLAUDE_CODE_WORKFLOW.md) - AI開発の最適化パターン
- [CI/CD パイプライン](docs/CICD_PIPELINE_GUIDE.md) - 完全自動化の設定

### 技術仕様
- [Cloudflare デプロイ](docs/CLOUDFLARE_DEPLOYMENT.md) - Workers デプロイ詳細
- [Claude.md](Claude.md) - AI開発ルール
- [templates/](templates/) - 再利用可能テンプレート

## 🎯 学習成果

### 効率化のキーポイント

1. **一括処理**: Claude Code で関連作業を1プロンプトで完結
2. **自動化徹底**: 手動作業をゼロに近づける
3. **品質妥協なし**: 自動化しても品質基準は維持
4. **コスト最適化**: 無料・低コストツールの組み合わせ

### 実証されたベストプラクティス

- **Self-hosted runner**: CI時間50%短縮、コスト削減
- **Vitest**: Jest比で高速、軽量
- **Cloudflare Workers**: 無料で世界配信
- **Claude Code**: 開発効率3-5倍向上

## 💡 次のステップ

1. **テンプレート活用**: 新規プロジェクトで即座に効率化開始
2. **カスタマイズ**: プロジェクト特有の要件に応じて調整  
3. **継続改善**: さらなる効率化要素の実験・追加

## 🤝 コントリビューション

このプロジェクトは個人開発効率化の実験です。改善提案やIssueは歓迎します。

## 📄 ライセンス

MIT License

---

**🎉 Happy Efficient Coding!**

*Claude Code + GitHub + Cloudflare で、個人開発の新しい標準を目指します*