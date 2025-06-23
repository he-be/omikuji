#!/bin/bash

# Claude Code + GitHub CI/CD クイックセットアップスクリプト
# 使用方法: ./quick-setup.sh [project-name]

PROJECT_NAME=${1:-"my-project"}

echo "🚀 Setting up CI/CD project: $PROJECT_NAME"

# プロジェクトディレクトリ作成
mkdir -p $PROJECT_NAME
cd $PROJECT_NAME

# Git初期化
git init

# 基本的なディレクトリ構造を作成
mkdir -p src/__tests__ .github/workflows docs

# package.json の作成
cat > package.json << 'EOF'
{
  "name": "PROJECT_NAME",
  "version": "1.0.0",
  "description": "A project with CI/CD pipeline",
  "main": "dist/index.js",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "dev": "ts-node src/index.ts",
    "test": "vitest run",
    "test:watch": "vitest",
    "test:coverage": "vitest run --coverage",
    "lint": "eslint . --ext .ts",
    "typecheck": "tsc --noEmit"
  },
  "keywords": [],
  "author": "",
  "license": "MIT",
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "@vitest/coverage-v8": "^1.0.0",
    "eslint": "^8.0.0",
    "ts-node": "^10.0.0",
    "typescript": "^5.0.0",
    "vitest": "^1.0.0"
  }
}
EOF

# プロジェクト名を置換
sed -i.bak "s/PROJECT_NAME/$PROJECT_NAME/g" package.json && rm package.json.bak

# TypeScript 設定
cat > tsconfig.json << 'EOF'
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
EOF

# Vitest 設定
cat > vitest.config.ts << 'EOF'
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
EOF

# ESLint 設定
cat > .eslintrc.json << 'EOF'
{
  "parser": "@typescript-eslint/parser",
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended"
  ],
  "plugins": ["@typescript-eslint"],
  "env": {
    "node": true,
    "es2020": true
  },
  "parserOptions": {
    "ecmaVersion": 2020,
    "sourceType": "module"
  },
  "rules": {
    "@typescript-eslint/explicit-function-return-type": "warn",
    "@typescript-eslint/no-unused-vars": ["error", { "argsIgnorePattern": "^_" }]
  }
}
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
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Temporary files
*.tmp
*.temp
.cache/
EOF

# 基本的な CI ワークフロー
cat > .github/workflows/ci.yml << 'EOF'
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
EOF

# サンプルソースコード
cat > src/index.ts << 'EOF'
export function greet(name: string): string {
  return `Hello, ${name}!`;
}

// 直接実行時の処理
if (require.main === module) {
  console.log(greet('World'));
}
EOF

# サンプルテストコード
cat > src/__tests__/index.test.ts << 'EOF'
import { describe, test, expect } from 'vitest';
import { greet } from '../index';

describe('greet function', () => {
  test('should return greeting message', () => {
    expect(greet('World')).toBe('Hello, World!');
  });
  
  test('should handle empty string', () => {
    expect(greet('')).toBe('Hello, !');
  });
});
EOF

# README.md
cat > README.md << EOF
# $PROJECT_NAME

A TypeScript project with automated CI/CD pipeline.

## Setup

\`\`\`bash
npm install
\`\`\`

## Development

\`\`\`bash
npm run dev
\`\`\`

## Testing

\`\`\`bash
npm test              # Run tests
npm run test:watch    # Watch mode
npm run test:coverage # Generate coverage report
\`\`\`

## Build

\`\`\`bash
npm run build
\`\`\`

## CI/CD Pipeline

This project includes:
- Automated testing on PR
- Code coverage reporting
- Type checking and linting
- Multi-platform builds

Generated with Claude Code quick setup script.
EOF

echo "✅ Project setup complete!"
echo ""
echo "Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. npm install"
echo "3. git add ."
echo "4. git commit -m 'Initial commit with CI/CD pipeline'"
echo "5. Create GitHub repository and push"
echo "6. Configure GitHub Actions permissions for coverage reports"
echo ""
echo "Happy coding! 🎉"