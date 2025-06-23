# Claude Code ワークフロー最適化ガイド

## 効率的な開発フローのパターン

### 1. プロジェクト初期セットアップ

```
User: TypeScript プロジェクトを作成して。Express API で、
テストとCI/CDパイプラインも設定して。

Claude: [自動的に以下を実行]
- プロジェクト構造の作成
- 依存関係のインストール
- TypeScript 設定
- テストフレームワーク設定
- GitHub Actions 設定
- 初期コミット
```

### 2. 機能追加フロー

```
User: ユーザー認証機能を追加して。JWT を使って。

Claude: [段階的に実行]
1. 必要なパッケージをインストール
2. 認証ミドルウェアを作成
3. ユーザーモデルを定義
4. 認証エンドポイントを実装
5. テストを作成
6. カバレッジを確認
7. PR を作成
```

### 3. テストカバレッジ改善

```
User: テストカバレッジを 80% 以上にして。

Claude: [分析と改善]
1. 現在のカバレッジレポートを確認
2. 未カバーのコードを特定
3. 不足しているテストケースを追加
4. エッジケースのテストを実装
5. カバレッジを再確認
```

## Claude Code の強みを活かすコツ

### 1. 一括処理の活用

❌ 非効率な例：
```
User: package.json を編集して
User: 次に tsconfig.json を編集して
User: 最後に vitest.config.ts を作成して
```

✅ 効率的な例：
```
User: TypeScript プロジェクトの設定ファイルを一括で作成して。
Vitest でテストできるようにして。
```

### 2. コンテキストを活用

❌ 非効率な例：
```
User: テストを書いて
Claude: どのファイルのテストですか？
User: src/api/users.ts のテスト
```

✅ 効率的な例：
```
User: src/api/users.ts の全関数に対するテストを書いて。
エラーケースも含めて。
```

### 3. 自動化の活用

```
User: このプロジェクトに新しい API エンドポイントを追加する時の
標準的な手順を自動化したい。

Claude: [以下を含むスクリプトを作成]
- ルートファイルの生成
- コントローラーの生成
- テストファイルの生成
- ドキュメントの更新
```

## CI/CD パイプラインのベストプラクティス

### 1. 段階的なチェック

```yaml
# 早期失敗の原則
jobs:
  quick-checks:      # 高速なチェック（〜1分）
    - lint
    - typecheck
  
  tests:            # 中速のチェック（〜5分）
    - unit-tests
    - integration-tests
  
  slow-checks:      # 低速なチェック（5分〜）
    - e2e-tests
    - security-scan
```

### 2. キャッシュの活用

```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20.x'
    cache: 'npm'  # 依存関係をキャッシュ

- uses: actions/cache@v3
  with:
    path: |
      ~/.npm
      node_modules
      .next/cache  # フレームワーク固有のキャッシュ
    key: ${{ runner.os }}-deps-${{ hashFiles('**/package-lock.json') }}
```

### 3. 並列実行

```yaml
strategy:
  matrix:
    test-suite: [unit, integration, e2e]
jobs:
  test:
    name: Run ${{ matrix.test-suite }} tests
    run: npm run test:${{ matrix.test-suite }}
```

## トラブルシューティングチェックリスト

### PR でカバレッジが表示されない

- [ ] GitHub Actions の権限設定を確認
- [ ] vitest.config.ts に json-summary レポーターが含まれているか
- [ ] coverage-report アクションが正しく設定されているか
- [ ] PR のターゲットブランチが正しいか

### テストが CI で失敗するがローカルでは成功

- [ ] 環境変数の違いを確認
- [ ] タイムゾーンの違いを確認
- [ ] ファイルパスの大文字小文字を確認（Windows vs Linux）
- [ ] 依存関係のバージョンロックを確認

### ビルドが遅い

- [ ] 不要な依存関係を削除
- [ ] キャッシュが効いているか確認
- [ ] 並列実行を検討
- [ ] ビルドステップの最適化

## 再利用可能なスニペット

### プロジェクト初期化

```bash
# Claude Code に依頼
"新しい TypeScript プロジェクトを作成して：
- Express API
- Vitest テスト
- ESLint + Prettier
- GitHub Actions CI/CD
- Docker 対応
- 環境変数管理"
```

### 機能追加テンプレート

```bash
# Claude Code に依頼
"新しい CRUD API を追加：
- リソース名: [resource]
- 認証必須
- バリデーション付き
- テスト込み
- OpenAPI ドキュメント生成"
```

### パフォーマンス改善

```bash
# Claude Code に依頼
"このプロジェクトのパフォーマンスを改善：
- ビルド時間の短縮
- テスト実行時間の短縮
- CI パイプラインの最適化
- 具体的な測定値を表示"
```