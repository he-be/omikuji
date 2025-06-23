#!/bin/bash

# 個人開発最適化プロジェクトセットアップスクリプト
# Claude Code + GitHub + Cloudflare Workers の完全統合版
# 使用方法: ./project-setup-optimized.sh [project-name]

PROJECT_NAME=${1:-"my-fullstack-project"}

echo "🚀 Setting up optimized fullstack project: $PROJECT_NAME"
echo "📦 Features: TypeScript + Vitest + GitHub Actions + Cloudflare Workers"

# プロジェクトディレクトリ作成
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Git初期化
git init

# ディレクトリ構造作成
mkdir -p src/__tests__ .github/workflows .claude docs templates

# package.json（最適化版）
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "Fullstack TypeScript project with optimized CI/CD",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "build:worker": "tsc src/worker.ts --outDir dist --target ES2022 --moduleResolution bundler --allowSyntheticDefaultImports",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts",
    "dev:worker": "wrangler dev src/worker.ts",
    "deploy": "wrangler deploy",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "lint": "eslint . --ext .ts --fix",
    "typecheck": "tsc --noEmit",
    "precommit": "npm run lint && npm run typecheck && npm run test"
  },
  "keywords": ["typescript", "fullstack", "cloudflare-workers", "claude-code"],
  "author": "",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.17",
    "@types/node": "^20.0.0",
    "@types/supertest": "^6.0.3",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "@vitest/coverage-v8": "^3.2.4",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "supertest": "^7.1.1",
    "ts-node": "^10.0.0",
    "typescript": "^5.0.0",
    "vitest": "^1.0.0",
    "wrangler": "^4.20.5"
  }
}
EOF

# TypeScript設定（最適化版）
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "commonjs",
    "lib": ["ES2022", "DOM"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "coverage"]
}
EOF

# Vitest設定（最適化版）
cat > vitest.config.ts << 'EOF'
import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'json', 'json-summary', 'html'],
      reportsDirectory: './coverage',
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 80,
        statements: 80
      },
      exclude: [
        'node_modules/',
        'dist/',
        '**/*.d.ts',
        '**/*.config.*',
        'coverage/**',
        'templates/**'
      ]
    },
    environment: 'node',
    globals: true
  }
})
EOF

# ESLint設定（厳格版）
cat > .eslintrc.json << 'EOF'
{
  "parser": "@typescript-eslint/parser",
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "@typescript-eslint/recommended-requiring-type-checking"
  ],
  "plugins": ["@typescript-eslint"],
  "env": {
    "node": true,
    "es2022": true
  },
  "parserOptions": {
    "ecmaVersion": 2022,
    "sourceType": "module",
    "project": "./tsconfig.json"
  },
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "error",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }],
    "@typescript-eslint/no-explicit-any": "error",
    "@typescript-eslint/prefer-const": "error",
    "@typescript-eslint/no-non-null-assertion": "error"
  }
}
EOF

# Prettier設定
cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false
}
EOF

# Cloudflare Workers設定
cat > wrangler.toml << EOF
name = "$PROJECT_NAME"
main = "dist/worker.js"
compatibility_date = "2024-01-01"

[env.production]
name = "$PROJECT_NAME"

[build]
command = "npm run build:worker"
EOF

# GitHub Actions CI/CD（self-hosted runner対応）
cat > .github/workflows/ci.yml << 'EOF'
name: CI/CD Pipeline

on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build-and-test:
    runs-on: self-hosted
    
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
      
      - name: Build for Cloudflare Workers
        run: npm run build:worker

  deploy:
    name: Deploy to Cloudflare Workers
    runs-on: self-hosted
    needs: build-and-test
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    
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
      
      - name: Build for Cloudflare Workers
        run: npm run build:worker
      
      - name: Deploy to Cloudflare Workers
        run: npm run deploy
        env:
          CLOUDFLARE_API_TOKEN: \${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: \${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
EOF

# Claude.md（個人開発最適化版）
cat > Claude.md << 'EOF'
# AI Development Constitution (CLAUDE.md)

このプロジェクトは個人開発効率化のための最適設定済みです。

## 個人開発最適化ルール

### 開発フロー
- GitHub Issues → ブランチ作成 → 実装 → テスト → PR → 自動デプロイ
- カバレッジ 80% 以上必須
- Self-hosted runner で高速 CI/CD
- Cloudflare Workers で世界配信

### Claude Code 効率化
- TodoWrite/TodoRead を頻繁に活用
- 一括処理でスピード重視
- テスト駆動開発必須
- デプロイまで自動化

### 技術スタック
- **フロントエンド**: TypeScript + 任意のフレームワーク
- **バックエンド**: Express.js（開発） + Cloudflare Workers（本番）
- **テスト**: Vitest + Supertest
- **CI/CD**: GitHub Actions（self-hosted）
- **デプロイ**: Cloudflare Workers

### 品質基準
- TypeScript strict mode 必須
- ESLint エラーゼロ
- テストカバレッジ 80%+
- 全 CI チェック通過

### コマンド
- `/check-ci` - CI確認・修正
- `/sync-main` - ブランチ同期
- `/deploy-test` - デプロイテスト
- `/setup-cloudflare` - Workers設定
EOF

# .claude/commands.md
cat > .claude/commands.md << 'EOF'
# Personal Development Optimization Commands

## /check-ci
GitHub Actions CI を確認し、失敗時は自動修正

## /sync-main  
main ブランチに戻って最新状態に同期

## /deploy-test
デプロイメントをテスト（ビルド→テスト→デプロイ→確認）

## /setup-cloudflare
Cloudflare Workers デプロイを既存プロジェクトに追加

## /fix-coverage
テストカバレッジを 80% 以上に改善

## /optimize-ci
CI/CD パイプラインのパフォーマンス最適化
EOF

# .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/

# Build output
dist/
*.js
*.js.map
*.d.ts
!vitest.config.ts
!.github/workflows/*.yml

# Cloudflare
.wrangler/

# Test coverage
coverage/
.nyc_output/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Environment
.env
.env.local
.env.*.local

# Logs
*.log
npm-debug.log*
EOF

# サンプル Express アプリ
cat > src/index.ts << 'EOF'
import express from 'express';

export const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

// サンプルエンドポイント
app.get('/', (req, res) => {
  res.json({ message: 'Hello World!', timestamp: new Date().toISOString() });
});

app.get('/health', (req, res) => {
  res.json({ status: 'OK', uptime: process.uptime() });
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`Server running on port ${port}`);
  });
}
EOF

# Cloudflare Workers版
cat > src/worker.ts << 'EOF'
export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);
    
    if (url.pathname === '/') {
      return new Response(JSON.stringify({
        message: 'Hello World!',
        timestamp: new Date().toISOString()
      }), {
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    if (url.pathname === '/health') {
      return new Response(JSON.stringify({
        status: 'OK',
        edge: 'Cloudflare Workers'
      }), {
        headers: { 'Content-Type': 'application/json' }
      });
    }
    
    return new Response('Not Found', { status: 404 });
  },
};
EOF

# テストファイル
cat > src/__tests__/index.test.ts << 'EOF'
import { describe, test, expect } from 'vitest';
import request from 'supertest';
import { app } from '../index';

describe('Express App', () => {
  test('GET / should return hello message', async () => {
    const response = await request(app).get('/');
    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Hello World!');
    expect(response.body.timestamp).toBeDefined();
  });

  test('GET /health should return status', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('OK');
    expect(response.body.uptime).toBeDefined();
  });
});
EOF

cat > src/__tests__/worker.test.ts << 'EOF'
import { describe, test, expect } from 'vitest';

describe('Cloudflare Workers', () => {
  test('should handle root path', async () => {
    const worker = await import('../worker');
    const request = new Request('https://example.com/');
    const response = await worker.default.fetch(request);
    
    expect(response.status).toBe(200);
    const json = await response.json() as { message: string };
    expect(json.message).toBe('Hello World!');
  });

  test('should handle health check', async () => {
    const worker = await import('../worker');
    const request = new Request('https://example.com/health');
    const response = await worker.default.fetch(request);
    
    expect(response.status).toBe(200);
    const json = await response.json() as { status: string };
    expect(json.status).toBe('OK');
  });
});
EOF

# README.md
cat > README.md << EOF
# $PROJECT_NAME

個人開発最適化済み TypeScript フルスタックプロジェクト

## 🚀 特徴

- **高速 CI/CD**: Self-hosted runner + 自動デプロイ
- **グローバル配信**: Cloudflare Workers
- **品質保証**: 80%+ テストカバレッジ
- **開発効率**: Claude Code 最適化

## 🛠 セットアップ

\`\`\`bash
npm install
\`\`\`

## 📝 開発

\`\`\`bash
npm run dev          # Express 開発サーバー
npm run dev:worker   # Workers 開発サーバー
npm run test         # テスト実行
npm run test:coverage # カバレッジ生成
\`\`\`

## 🚢 デプロイ

1. GitHub Secrets に設定:
   - \`CLOUDFLARE_API_TOKEN\`
   - \`CLOUDFLARE_ACCOUNT_ID\`

2. main ブランチにプッシュで自動デプロイ

## 🤖 Claude Code コマンド

- \`/check-ci\` - CI確認・修正
- \`/sync-main\` - ブランチ同期  
- \`/deploy-test\` - デプロイテスト

## 📊 品質基準

- TypeScript strict mode ✅
- テストカバレッジ 80%+ ✅  
- ESLint エラーゼロ ✅
- 自動デプロイ ✅

Personal Development Optimized by Claude Code
EOF

echo "✅ Project setup complete!"
echo ""
echo "🔧 Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. npm install"
echo "3. git add . && git commit -m 'Initial setup'"
echo "4. Create GitHub repository and push"
echo "5. Add Cloudflare secrets to GitHub repository"
echo "6. Start developing with Claude Code! 🚀"
echo ""
echo "📚 Features ready:"
echo "  - TypeScript strict mode + Vitest"
echo "  - GitHub Actions self-hosted runner"
echo "  - Cloudflare Workers deployment"
echo "  - Claude Code optimization"
echo "  - 80%+ test coverage enforcement"
echo ""
echo "Happy coding! 🎉"