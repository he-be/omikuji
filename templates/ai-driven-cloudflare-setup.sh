#!/bin/bash

# AI駆動開発最適化 Cloudflare Workers プロジェクトセットアップ
# 基盤: AUTOMATION_GUIDELINE.md + LESSONS_LEARNED.md の知見を反映
# 使用方法: ./ai-driven-cloudflare-setup.sh [project-name]

PROJECT_NAME=${1:-"my-ai-project"}

echo "🤖 Setting up AI-driven Cloudflare Workers project: $PROJECT_NAME"
echo "📋 Features: 4-Layer Verification System + Self-Correcting AI Environment"

# プロジェクトディレクトリ作成
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Git初期化
git init

# ディレクトリ構造作成（AI駆動開発最適化）
mkdir -p src/__tests__ e2e .github/workflows docs .husky

# package.json（統一されたCloudflare Workersアーキテクチャ）
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "1.0.0",
  "description": "AI-driven Cloudflare Workers project with self-correcting environment",
  "main": "src/index.ts",
  "scripts": {
    "dev": "wrangler dev src/index.ts",
    "build": "vite build",
    "deploy": "wrangler deploy",
    "test": "vitest run",
    "test:unit": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "test:e2e": "playwright test",
    "test:e2e:ui": "playwright test --ui",
    "lint": "eslint 'src/**/*.{js,jsx,ts,tsx}'",
    "lint:fix": "eslint 'src/**/*.{js,jsx,ts,tsx}' --fix",
    "format": "prettier --write 'src/**/*.{js,jsx,ts,tsx,json,css,md}'",
    "format:check": "prettier --check 'src/**/*.{js,jsx,ts,tsx,json,css,md}'",
    "typecheck": "tsc --noEmit",
    "prepare": "husky"
  },
  "keywords": ["ai-driven", "cloudflare-workers", "typescript", "vite", "playwright"],
  "author": "",
  "license": "MIT",
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "vitest related --run"
    ],
    "*.{js,jsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,css,md}": [
      "prettier --write"
    ]
  },
  "devDependencies": {
    "@cloudflare/workers-types": "^4.20250628.0",
    "@eslint/js": "^9.30.0",
    "@playwright/test": "^1.53.1",
    "@types/node": "^20.5.0",
    "@typescript-eslint/eslint-plugin": "^8.35.0",
    "@typescript-eslint/parser": "^8.35.0",
    "@vitest/coverage-v8": "^3.2.4",
    "eslint": "^9.30.0",
    "eslint-config-prettier": "^10.1.5",
    "globals": "^16.2.0",
    "husky": "^9.1.7",
    "lint-staged": "^16.1.2",
    "miniflare": "^4.20250617.4",
    "prettier": "^3.6.2",
    "typescript": "^5.1.6",
    "vite": "^7.0.0",
    "vitest": "^3.2.4",
    "wrangler": "^4.20.5"
  }
}
EOF

# TypeScript設定（strict mode + Cloudflare Workers最適化）
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ESNext",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "lib": ["ESNext"],
    "jsx": "react-jsx",
    "strict": true,
    "esModuleInterop": true,
    "isolatedModules": true,
    "noEmit": true,
    "skipLibCheck": true,
    "types": ["@cloudflare/workers-types", "vite/client"]
  },
  "include": ["src", "worker"],
  "references": [{ "path": "./tsconfig.node.json" }]
}
EOF

# tsconfig.node.json（Node.js環境用）
cat > tsconfig.node.json << 'EOF'
{
  "compilerOptions": {
    "composite": true,
    "skipLibCheck": true,
    "module": "ESNext",
    "moduleResolution": "bundler",
    "allowSyntheticDefaultImports": true
  },
  "include": ["vite.config.ts", "playwright.config.ts"]
}
EOF

# Vite設定（Cloudflare Workers + Vitest統合）
cat > vite.config.ts << 'EOF'
import { defineConfig } from 'vite'
import { defineConfig as defineVitestConfig } from 'vitest/config'

// Merge Vite and Vitest configs
export default defineConfig(
  defineVitestConfig({
    test: {
      globals: true,
      environment: 'node',
      include: ['src/**/*.{test,spec}.{js,mjs,cjs,ts,mts,cts,jsx,tsx}'],
      exclude: ['e2e/**', 'node_modules/**', 'dist/**'],
      coverage: {
        provider: 'v8',
        reporter: ['text', 'json', 'json-summary', 'html'],
        reportsDirectory: './coverage',
        exclude: [
          'node_modules/',
          'dist/',
          'e2e/',
          '**/*.d.ts',
          '**/*.config.*',
          'coverage/**'
        ]
      }
    },
    build: {
      target: 'es2022',
      outDir: 'dist',
      emptyOutDir: true,
      minify: true,
      rollupOptions: {
        input: './src/index.ts',
        output: {
          format: 'es'
        }
      }
    },
    resolve: {
      alias: {
        '@': '/src'
      }
    }
  })
)
EOF

# ESLint設定（フラット設定 + TypeScript最適化）
cat > eslint.config.js << 'EOF'
const eslint = require('@eslint/js');
const tseslint = require('@typescript-eslint/eslint-plugin');
const tsparser = require('@typescript-eslint/parser');
const prettierConfig = require('eslint-config-prettier');
const globals = require('globals');

module.exports = [
  eslint.configs.recommended,
  prettierConfig,
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    languageOptions: {
      parser: tsparser,
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
      },
      globals: {
        ...globals.node,
        ...globals.browser,
        // Cloudflare Workers globals
        Request: 'readonly',
        Response: 'readonly',
        URL: 'readonly',
        fetch: 'readonly',
      },
    },
    plugins: {
      '@typescript-eslint': tseslint,
    },
    rules: {
      ...tseslint.configs.recommended.rules,
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/explicit-module-boundary-types': 'off',
      '@typescript-eslint/no-explicit-any': 'warn',
      'no-console': 'off',
      'no-debugger': 'error',
    },
  },
  {
    ignores: ['dist/', 'node_modules/', 'coverage/', '*.config.js', '*.config.ts'],
  }
];
EOF

# Prettier設定
cat > .prettierrc << 'EOF'
{
  "printWidth": 100,
  "tabWidth": 2,
  "useTabs": false,
  "semi": true,
  "singleQuote": true,
  "quoteProps": "as-needed",
  "jsxSingleQuote": false,
  "trailingComma": "es5",
  "bracketSpacing": true,
  "arrowParens": "always",
  "proseWrap": "preserve",
  "htmlWhitespaceSensitivity": "css",
  "endOfLine": "lf"
}
EOF

cat > .prettierignore << 'EOF'
dist/
coverage/
node_modules/
*.log
package-lock.json
.git/
EOF

# Playwright設定（CI最適化版）
cat > playwright.config.ts << 'EOF'
import { defineConfig, devices } from '@playwright/test';

/**
 * Playwright configuration for E2E testing with Cloudflare Workers
 * Uses wrangler dev to serve the application locally
 */
export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: 'html',
  
  use: {
    baseURL: 'http://localhost:8787',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    // CI環境での追加設定
    ...(process.env.CI && {
      video: 'retain-on-failure',
      headless: true,
    }),
  },

  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    
    // CI環境では軽量化のためchromiumのみを使用
    ...(process.env.CI ? [] : [
      {
        name: 'firefox',
        use: { ...devices['Desktop Firefox'] },
      },

      {
        name: 'webkit',
        use: { ...devices['Desktop Safari'] },
      },
    ]),
  ],

  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:8787',
    reuseExistingServer: !process.env.CI,
  },
});
EOF

# Cloudflare Workers設定
cat > wrangler.toml << EOF
name = "$PROJECT_NAME"
main = "src/index.ts"
compatibility_date = "2024-01-01"

# Development settings
[dev]
port = 8787
local_protocol = "http"

# Production environment
[env.production]
name = "$PROJECT_NAME"

# Build settings
[build]
command = "npm run build"

# Miniflare settings for local development
[miniflare]
# Enable KV namespaces, Durable Objects, etc. when needed
kv_persist = true
EOF

# Husky pre-commit hook
cat > .husky/pre-commit << 'EOF'
npx lint-staged
EOF
chmod +x .husky/pre-commit

# GitHub Actions CI/CD（最新ベストプラクティス）
cat > .github/workflows/ci.yml << 'EOF'
# ワークフローの名前
name: CI/CD Pipeline - Cloudflare Workers

# ワークフローが実行されるタイミングを定義
on:
  # mainブランチにプッシュされた時
  push:
    branches: [ "main" ]
  # mainブランチに向けたプルリクエストが作成・更新された時
  pull_request:
    branches: [ "main" ]

# 実行される一連のタスク（ジョブ）を定義
jobs:
  # 品質チェック、テスト、ビルドを実行するジョブ
  build-and-test:
    # ジョブを実行する仮想環境の種類（最新のUbuntu）
    runs-on: ubuntu-latest

    # ジョブ内のステップ（実行されるコマンド）
    steps:
      # 1. リポジトリのコードを仮想環境にチェックアウトする
      - name: Checkout code
        uses: actions/checkout@v4

      # 2. Node.js環境をセットアップする
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          # 使用するNode.jsのバージョンを指定
          node-version: '20.x'
          # npmの依存関係をキャッシュして、次回以降の実行を高速化する
          cache: 'npm'

      # 3. 依存関係をインストールする
      # 'npm install'ではなく'npm ci'を使うことで、package-lock.jsonに基づいた高速でクリーンなインストールを行う
      - name: Install dependencies
        run: npm ci

      # 4. コードの静的解析（リンター）を実行する
      - name: Run lint
        run: npm run lint

      # 5. TypeScriptの型チェックを実行する
      - name: Run typecheck
        run: npm run typecheck

      # 6. 単体テストを実行する
      - name: Run unit tests
        run: npm run test:unit

      # 7. カバレッジレポートを生成する
      - name: Generate coverage report
        run: npm run test:coverage

      # 8. カバレッジレポートをPRにコメントする
      - name: Coverage Report
        if: github.event_name == 'pull_request'
        uses: davelosert/vitest-coverage-report-action@v2

      # 9. Playwrightブラウザのインストール
      - name: Install Playwright browsers
        run: npx playwright install chromium

      # 10. E2Eテストを実行する（ヘッドレスモード）
      - name: Run E2E tests
        run: npm run test:e2e
        env:
          CI: true

      # 11. プロジェクトのビルド
      - name: Build project
        run: npm run build

  # Cloudflare Workers へのデプロイ（mainブランチのみ）
  deploy:
    name: Deploy to Cloudflare Workers
    runs-on: ubuntu-latest
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
        run: npm run build
      
      - name: Deploy to Cloudflare Workers
        run: npm run deploy
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
EOF

# .gitignore（Cloudflare Workers最適化）
cat > .gitignore << 'EOF'
# Dependencies
node_modules/

# Build output
dist/
*.js
*.js.map
*.d.ts
!vite.config.ts
!playwright.config.ts
!eslint.config.js

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

# Temporary files
*.tmp
*.temp
.cache/

# Playwright
/test-results/
/playwright-report/
/blob-report/
/playwright/.cache/
EOF

# CLAUDE.md（AI駆動開発最適化版）
cat > CLAUDE.md << EOF
# $PROJECT_NAME - AI Development Context

このプロジェクトは、AI駆動開発に最適化されたCloudflare Workersアプリケーションです。

## プロジェクト概要

**技術スタック**: Cloudflare Workers + TypeScript + Vite + Vitest + Playwright

### 自己修正型開発環境

このプロジェクトは4層の検証システムを実装しています：

\`\`\`
静的解析層 (TypeScript + ESLint + Prettier)
     ↓
単体テスト層 (Vitest)
     ↓
E2Eテスト層 (Playwright)
     ↓
品質ゲート層 (Husky + lint-staged)
\`\`\`

## AIエージェントへの重要な指示

### ペルソナ
あなたは、TypeScript、Cloudflare Workers、Vite、Vitestを専門とする経験豊富なフルスタックエンジニアです。高品質で、テストされ、保守可能なコードを書くことが目標です。

### コアディレクティブ

1. **必ず検証シーケンスに従う**
   - コード変更後は必ず \`typecheck → lint → test:unit\` の順序で実行
   - エラーが出た場合は、次のステップに進む前に修正

2. **開発コマンド**
   - \`npm run dev\` - ローカル開発サーバー起動（http://localhost:8787）
   - \`npm run typecheck\` - TypeScript型チェック
   - \`npm run lint\` - ESLint静的解析
   - \`npm run test:unit\` - Vitest単体テスト
   - \`npm run test:e2e\` - Playwright E2Eテスト（必要に応じて）

3. **データ整合性の維持**
   - テストデータは実装と厳密に一致させる
   - UIテストは実際のHTML構造を反映
   - 共通定数は単一箇所で管理

4. **Cloudflare Workers環境への配慮**
   - Node.js固有のAPIは使用しない
   - Workersの制限（CPU時間、メモリ）を考慮
   - 適切なHTTPレスポンスヘッダーを設定

## 現在の実装状況

### 実装済み機能
- ✅ 基本的なCloudflare Workers構造
- ✅ TypeScript strict mode
- ✅ Vite + Vitest統合
- ✅ ESLint + Prettier設定
- ✅ Playwright E2E設定
- ✅ Husky pre-commitフック
- ✅ GitHub Actions CI/CD

### 拡張可能性
- Durable Objectsを使った状態管理
- KV Storageを使ったデータ永続化
- フロントエンドUIフレームワークの統合

---

このドキュメントは、AIエージェントが自律的かつ効率的に開発を進めるためのガイドラインです。
EOF

# サンプルCloudflare Workersアプリ
cat > src/index.ts << 'EOF'
// Cloudflare Workers サンプルアプリケーション

export const sampleData = ['Hello', 'World', 'AI', 'Driven', 'Development'];

export function getRandomItem(): string {
  const randomIndex = Math.floor(Math.random() * sampleData.length);
  return sampleData[randomIndex];
}

function generateHTML(message: string): string {
  return \`
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>\${message}</title>
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
        .container {
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
        .message {
            font-size: 24px;
            font-weight: bold;
            color: #007acc;
            margin: 20px 0;
            padding: 20px;
            border: 2px solid #007acc;
            border-radius: 10px;
        }
        .reload-button {
            background-color: #007acc;
            color: white;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
            margin-top: 20px;
            display: inline-block;
        }
        .reload-button:hover {
            background-color: #005999;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>AI-Driven Development Sample</h1>
        <div class="message">\${message}</div>
        <a href="/" class="reload-button">Generate New</a>
    </div>
</body>
</html>
  \`;
}

export default {
  async fetch(request: Request): Promise<Response> {
    const url = new URL(request.url);

    // ルートパスの処理
    if (url.pathname === '/') {
      const message = getRandomItem();
      const html = generateHTML(message);

      return new Response(html, {
        headers: {
          'Content-Type': 'text/html; charset=utf-8',
          'Cache-Control': 'no-cache',
        },
      });
    }

    // APIエンドポイント（JSON）
    if (url.pathname === '/api/random') {
      const message = getRandomItem();

      return new Response(JSON.stringify({ message }), {
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
EOF

# サンプル単体テスト
cat > src/__tests__/index.test.ts << 'EOF'
import { describe, test, expect } from 'vitest';
import { getRandomItem, sampleData } from '../index';

// Cloudflare Workers環境をモック
const mockRequest = (url: string, method = 'GET') => new Request(url, { method });

describe('AI-Driven Development Sample App', () => {
  describe('getRandomItem function', () => {
    test('should return a valid item from sampleData', () => {
      const result = getRandomItem();
      expect(sampleData).toContain(result);
    });

    test('should return one of the five possible items', () => {
      const results = new Set();
      for (let i = 0; i < 100; i++) {
        results.add(getRandomItem());
      }
      expect(results.size).toBeGreaterThan(0);
      expect(results.size).toBeLessThanOrEqual(sampleData.length);
    });
  });

  describe('Worker fetch handler', () => {
    test('should handle root path request', async () => {
      // Dynamic import for worker
      const worker = await import('../index');
      const request = mockRequest('https://example.com/');
      
      const response = await worker.default.fetch(request);
      
      expect(response.status).toBe(200);
      expect(response.headers.get('Content-Type')).toContain('text/html');
      
      const html = await response.text();
      expect(html).toContain('<!DOCTYPE html>');
      expect(html).toContain('<title>');
      expect(html).toContain('class="message"');
      expect(html).toContain('Generate New');
    });

    test('should handle API endpoint', async () => {
      const worker = await import('../index');
      const request = mockRequest('https://example.com/api/random');
      
      const response = await worker.default.fetch(request);
      
      expect(response.status).toBe(200);
      expect(response.headers.get('Content-Type')).toBe('application/json');
      expect(response.headers.get('Access-Control-Allow-Origin')).toBe('*');
      
      const json = await response.json() as { message: string };
      expect(sampleData).toContain(json.message);
    });

    test('should return 404 for unknown paths', async () => {
      const worker = await import('../index');
      const request = mockRequest('https://example.com/unknown');
      
      const response = await worker.default.fetch(request);
      
      expect(response.status).toBe(404);
      expect(await response.text()).toBe('Not Found');
    });

    test('should include proper cache headers for HTML', async () => {
      const worker = await import('../index');
      const request = mockRequest('https://example.com/');
      
      const response = await worker.default.fetch(request);
      
      expect(response.headers.get('Cache-Control')).toBe('no-cache');
    });
  });
});
EOF

# サンプルE2Eテスト
cat > e2e/sample.spec.ts << 'EOF'
import { test, expect } from '@playwright/test';

test.describe('AI-Driven Development Sample App E2E Tests', () => {
  test('should display sample page with valid message', async ({ page }) => {
    // Navigate to the sample page
    await page.goto('/');

    // Check page title contains one of our sample messages
    await expect(page).toHaveTitle(/Hello|World|AI|Driven|Development/);

    // Check that the page contains a message
    const messageElement = page.locator('.message');
    await expect(messageElement).toBeVisible();

    // Check that the message is one of the valid sample data
    const messageText = await messageElement.textContent();
    expect(['Hello', 'World', 'AI', 'Driven', 'Development']).toContain(messageText);

    // Check that the "Generate New" button is present and clickable
    const generateButton = page.locator('a:has-text("Generate New")');
    await expect(generateButton).toBeVisible();
    await expect(generateButton).toHaveAttribute('href', '/');
  });

  test('should be able to generate new messages', async ({ page }) => {
    await page.goto('/');

    // Click "Generate New" button
    await page.click('a:has-text("Generate New")');

    // Wait for page to reload and check that we have a message
    await page.waitForLoadState('networkidle');
    const messageElement = page.locator('.message');
    await expect(messageElement).toBeVisible();

    // Verify the new message is valid
    const newMessage = await messageElement.textContent();
    expect(['Hello', 'World', 'AI', 'Driven', 'Development']).toContain(newMessage || '');
  });

  test('should return valid JSON from API endpoint', async ({ page }) => {
    // Make a direct request to the API endpoint
    const response = await page.request.get('/api/random');
    
    expect(response.status()).toBe(200);
    expect(response.headers()['content-type']).toBe('application/json');
    expect(response.headers()['access-control-allow-origin']).toBe('*');

    const jsonData = await response.json();
    expect(jsonData).toHaveProperty('message');
    expect(['Hello', 'World', 'AI', 'Driven', 'Development']).toContain(jsonData.message);
  });

  test('should return 404 for unknown paths', async ({ page }) => {
    const response = await page.request.get('/unknown-path');
    expect(response.status()).toBe(404);
    expect(await response.text()).toBe('Not Found');
  });

  test('should have proper cache headers', async ({ page }) => {
    const response = await page.request.get('/');
    expect(response.status()).toBe(200);
    expect(response.headers()['cache-control']).toBe('no-cache');
    expect(response.headers()['content-type']).toContain('text/html');
  });
});
EOF

# README.md
cat > README.md << EOF
# $PROJECT_NAME

AI駆動開発最適化済み Cloudflare Workers プロジェクト

## 🤖 AI-Driven Development Features

- **4層検証システム**: 静的解析 → 単体テスト → E2E → 品質ゲート
- **自己修正型環境**: AIエージェントが自律的に品質チェック
- **統一アーキテクチャ**: Cloudflare Workers単一実装
- **高速フィードバック**: Vite + Miniflare + Vitest統合

## 🚀 Quick Start

\`\`\`bash
npm install
npm run dev          # 開発サーバー起動 (http://localhost:8787)
\`\`\`

## 🔧 Development Commands

### 必須検証シーケンス
\`\`\`bash
npm run typecheck    # TypeScript型チェック
npm run lint         # ESLint静的解析  
npm run test:unit    # Vitest単体テスト
npm run test:e2e     # Playwright E2E（必要に応じて）
\`\`\`

### その他のコマンド
\`\`\`bash
npm run build        # プロジェクトビルド
npm run deploy       # Cloudflareにデプロイ
npm run format       # Prettierフォーマット
npm run test:coverage # カバレッジレポート生成
\`\`\`

## 🛠 Project Structure

\`\`\`
$PROJECT_NAME/
├── src/
│   ├── index.ts           # メインWorkerファイル
│   └── __tests__/
│       └── index.test.ts  # 単体テスト
├── e2e/
│   └── sample.spec.ts     # E2Eテスト
├── .github/workflows/
│   └── ci.yml            # GitHub Actions CI/CD
├── vite.config.ts        # Vite + Vitest設定
├── playwright.config.ts  # Playwright設定
├── wrangler.toml        # Cloudflare Workers設定
└── CLAUDE.md           # AI開発コンテキスト
\`\`\`

## 🔄 CI/CD Pipeline

GitHub Actionsで以下を自動実行：

1. **静的解析**: TypeScript + ESLint
2. **単体テスト**: Vitest + カバレッジ
3. **E2Eテスト**: Playwright (Chromium)
4. **ビルド**: Vite
5. **デプロイ**: Cloudflare Workers (mainブランチ)

## 🌐 Deployment

1. GitHub Secrets に設定:
   - \`CLOUDFLARE_API_TOKEN\`
   - \`CLOUDFLARE_ACCOUNT_ID\`

2. mainブランチにプッシュで自動デプロイ

## 📋 AI Agent Guidelines

このプロジェクトは **CLAUDE.md** を参照してAI駆動開発を行ってください：

- 必ず検証シーケンス（typecheck → lint → test:unit）に従う
- テストデータは実装と厳密に一致させる
- エラーは各層で異なる種類の問題を示す

## 🎯 Quality Standards

- ✅ TypeScript strict mode
- ✅ ESLint エラーゼロ  
- ✅ Pre-commitフック
- ✅ 自動テスト実行
- ✅ E2E検証

---

*Generated with AI-Driven Cloudflare Workers Setup Script*
*Based on AUTOMATION_GUIDELINE.md + LESSONS_LEARNED.md*
EOF

echo "✅ AI-driven project setup complete!"
echo ""
echo "🤖 Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. npm install"
echo "3. git add . && git commit -m 'Initial AI-driven setup'"
echo "4. Create GitHub repository and push"
echo "5. Add Cloudflare secrets to GitHub repository"
echo "6. Start AI-driven development! 🚀"
echo ""
echo "📚 Features implemented:"
echo "  - 4-Layer Verification System (TypeScript + ESLint + Vitest + Playwright)"
echo "  - Self-Correcting AI Environment (Husky + lint-staged)"
echo "  - Unified Cloudflare Workers Architecture"
echo "  - High-Speed Feedback Loop (Vite + Miniflare)"
echo "  - CI/CD with E2E Testing"
echo "  - AI Agent Optimized (CLAUDE.md)"
echo ""
echo "🎉 Ready for AI-driven development!"
EOF

chmod +x templates/ai-driven-cloudflare-setup.sh