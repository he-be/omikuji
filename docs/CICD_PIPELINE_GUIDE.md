# Claude Code + GitHub CI/CD パイプライン構築ガイド

このガイドは、Claude Code と GitHub を組み合わせた効率的な CI/CD パイプラインの構築方法をまとめたものです。

## 目次

1. [概要](#概要)
2. [基本セットアップ](#基本セットアップ)
3. [テストカバレッジの設定](#テストカバレッジの設定)
4. [CI/CD ワークフロー](#cicd-ワークフロー)
5. [Claude Code での効率的な開発フロー](#claude-code-での効率的な開発フロー)
6. [トラブルシューティング](#トラブルシューティング)

## 概要

### 主要コンポーネント

- **Claude Code**: AI アシスタントによるコード生成・修正
- **GitHub Actions**: CI/CD パイプライン
- **Vitest**: 高速なテストランナー（Jest 互換）
- **Coverage Report Action**: PR へのカバレッジレポート自動投稿

### メリット

1. AI による迅速なコード生成とテスト作成
2. 自動的なコード品質チェック
3. PR ごとのカバレッジ可視化
4. 継続的な品質改善サイクル

## 基本セットアップ

### 1. プロジェクト初期化

```bash
npm init -y
npm install -D typescript @types/node ts-node
npm install -D vitest @vitest/coverage-v8
npm install -D supertest @types/supertest  # API テスト用
```

### 2. TypeScript 設定

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "coverage"]
}
```

### 3. パッケージスクリプト

```json
// package.json
{
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "lint": "eslint . --ext .ts",
    "typecheck": "tsc --noEmit"
  }
}
```

## テストカバレッジの設定

### 1. Vitest 設定

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'json-summary', 'html'],
      reportsDirectory: './coverage',
      exclude: [
        'node_modules/',
        'dist/',
        '**/*.d.ts',
        '**/*.config.*',
        'coverage/**'
      ]
    }
  }
})
```

### 2. テスト可能なコード構造

```typescript
// src/index.ts
import express from 'express';

// テスト用にエクスポート
export const app = express();

// 関数もエクスポート
export function myFunction() {
  // ...
}

// 直接実行時のみサーバー起動
if (require.main === module) {
  const port = process.env.PORT || 3000;
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
}
```

## CI/CD ワークフロー

### 基本的な GitHub Actions ワークフロー

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20.x'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run lint
        run: npm run lint
      
      - name: Run typecheck
        run: npm run typecheck
      
      - name: Run tests
        run: npm test
      
      - name: Generate coverage report
        run: npm run test:coverage
      
      - name: Coverage Report
        if: github.event_name == 'pull_request'
        uses: davelosert/vitest-coverage-report-action@v2
```

### 高度な設定オプション

```yaml
# マトリクスビルド（複数の Node.js バージョン）
strategy:
  matrix:
    node-version: [18.x, 20.x, 21.x]
    os: [ubuntu-latest, windows-latest, macos-latest]

# アーティファクトの保存
- name: Upload coverage reports
  uses: actions/upload-artifact@v3
  with:
    name: coverage-report
    path: coverage/

# デプロイメントステップ
- name: Deploy to production
  if: github.ref == 'refs/heads/main'
  run: |
    # デプロイコマンド
```

## Claude Code での効率的な開発フロー

### 1. テスト駆動開発のプロンプト例

```
「TypeScript で Express API を作成して。以下の要件で：
1. GET /api/users - ユーザー一覧を返す
2. POST /api/users - 新規ユーザー作成
3. 各エンドポイントのテストも作成
4. 80%以上のカバレッジを目指す」
```

### 2. CI/CD 設定の依頼

```
「GitHub Actions の CI パイプラインを設定して：
1. TypeScript のビルドとテスト
2. ESLint による lint チェック
3. PR にカバレッジレポートを表示
4. main ブランチへのマージ時に自動デプロイ」
```

### 3. 段階的な改善

```
「現在のテストカバレッジが 60% なので、80% まで上げたい。
未カバーの部分を特定してテストを追加して」
```

## トラブルシューティング

### よくある問題と解決策

#### 1. カバレッジレポートが PR に表示されない

**原因**: GitHub Actions の権限不足

**解決策**:
1. リポジトリの Settings → Actions → General
2. "Workflow permissions" を "Read and write permissions" に設定
3. PR を再実行

#### 2. Vitest で `describe is not defined` エラー

**原因**: Vitest の関数がインポートされていない

**解決策**:
```typescript
import { describe, test, expect } from 'vitest';
```

#### 3. テスト時にモジュールが見つからない

**原因**: TypeScript のパス解決の問題

**解決策**:
```json
// tsconfig.json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["src/*"]
    }
  }
}
```

## ベストプラクティス

### 1. コミットメッセージ

Claude Code が生成するコミットメッセージのフォーマット：
```
<type>: <description>

- 詳細な変更点1
- 詳細な変更点2

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### 2. PR の作成

```bash
gh pr create --title "タイトル" --body "$(cat <<'EOF'
## Summary
- 変更の概要

## Changes
- 具体的な変更点

## Test plan
- [ ] テスト項目1
- [ ] テスト項目2

🤖 Generated with [Claude Code](https://claude.ai/code)
EOF
)"
```

### 3. テストの構造

```typescript
describe('機能名', () => {
  beforeEach(() => {
    // セットアップ
  });

  afterEach(() => {
    // クリーンアップ
  });

  describe('サブ機能', () => {
    test('期待される動作', () => {
      // テスト実装
    });
  });
});
```

## 再利用可能なテンプレート

このガイドの設定は、以下のようなプロジェクトに適用できます：

- Node.js/TypeScript API
- React/Vue/Angular アプリケーション
- CLI ツール
- npm パッケージ

プロジェクトタイプに応じて、追加の設定（例：E2E テスト、ビルド最適化）を加えることで、さらに強力なパイプラインを構築できます。