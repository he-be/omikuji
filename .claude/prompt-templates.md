# Prompt Templates for Claude Code

## CI/CD Templates

### GitHub Actions Troubleshooting
```
GitHub Actions の CI を確認し、問題があれば修正してください。

手順：
1. gh コマンドで現在の PR の CI 状況を確認
2. 実行中の場合は 1 分待機
3. 失敗がある場合は詳細を調査
4. ローカルで再現して修正
5. 修正をコミット・プッシュ
```

### Branch Synchronization
```
作業ブランチから main ブランチに戻って最新状態に同期してください。

手順：
1. git status で更新漏れがないか確認
2. git switch main で main ブランチに移動
3. git pull で最新状態に更新
4. 更新内容と現状を報告
```

### Test Coverage Improvement
```
テストカバレッジを {target}% 以上に改善してください。

要件：
- 現在のカバレッジレポートを分析
- 未カバー部分を特定
- 不足テストケースを追加
- エッジケース・エラーケースを含める
```

## Development Templates

### Feature Implementation
```
{feature-name} 機能を実装してください。

要件：
- テスト駆動開発で実装
- TypeScript strict mode 準拠
- カバレッジ 80% 以上
- ESLint エラーゼロ
- 包括的なテストケース
```

### API Endpoint Creation
```
{endpoint-path} API エンドポイントを作成してください。

仕様：
- HTTP メソッド: {method}
- 認証: {auth-required}
- バリデーション: {validation-rules}
- レスポンス形式: JSON
- エラーハンドリング込み
- supertest でテスト作成
```

## Project Setup Templates

### TypeScript Project Init
```
新しい TypeScript プロジェクトをセットアップしてください。

含める要素：
- TypeScript strict mode
- Vitest + coverage
- ESLint + Prettier
- GitHub Actions CI/CD
- Docker 対応（オプション）
- Claude.md 配置
```

### Express API Setup
```
Express API プロジェクトを作成してください。

技術スタック：
- Node.js 20.x
- TypeScript
- Express.js
- Vitest (テスト)
- GitHub Actions (CI/CD)
- 認証機能（JWT）
- データベース: {database-type}
```

## Maintenance Templates

### Security Update
```
セキュリティ関連の更新を実行してください。

タスク：
- npm audit の実行と修正
- 依存関係の更新
- 脆弱性の対応
- セキュリティテストの追加
- CI にセキュリティチェック組み込み
```

### Performance Optimization
```
パフォーマンスを最適化してください。

対象：
- ビルド時間の短縮
- テスト実行時間の改善
- CI パイプラインの高速化
- 実行時パフォーマンスの向上
- メモリ使用量の最適化
```

## Documentation Templates

### README Update
```
README.md を包括的に更新してください。

含める内容：
- プロジェクト概要
- インストール手順
- 使用方法
- API ドキュメント
- 開発者向けガイド
- CI/CD 情報
- ライセンス情報
```

### API Documentation
```
API ドキュメントを生成してください。

要件：
- OpenAPI/Swagger 形式
- 全エンドポイントをカバー
- リクエスト・レスポンス例
- 認証方法の説明
- エラーコード一覧
- 自動生成設定
```