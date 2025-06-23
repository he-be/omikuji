# AI Development Constitution (CLAUDE.md)

This document contains the core rules and principles for AI-driven development in this project. You MUST follow all rules listed here when you write or modify code, create commits, or perform any other development task.

---

## 1. Core Development Rules (中核となる開発ルール)

### 1.1. Language and Style
- All code MUST be written in TypeScript.
- Code style MUST strictly adhere to the project's `.eslintrc.js` and `.prettierrc` configurations. Run the linter/formatter before finalizing your changes.

### 1.2. Type Safety
- All function arguments, return values, and variable declarations MUST have explicit type definitions.
- The use of `any` is strictly forbidden. If a type cannot be determined, use `unknown` and perform type checking.

### 1.3. Modularity and Function Design
- Functions MUST be small and adhere to the Single Responsibility Principle (SRP). A single function should ideally be no longer than 50 lines.
- Create pure functions whenever possible. Avoid side effects.

### 1.4. Documentation
- All exported functions, classes, and types MUST have JSDoc comments.
- The JSDoc should explain the purpose of the code, all parameters (`@param`), and the return value (`@returns`).

### 1.5. Error Handling
- Potentially failing operations (e.g., API calls, file I/O) MUST be wrapped in `try...catch` blocks.
- Do not use generic `Error`. Create custom error classes or use specific error types where appropriate.

---

## 2. Testing Requirements (テスト要件)

### 2.1. Test Strategy
- Every new feature or bug fix MUST be accompanied by corresponding unit tests using Vitest.
- Business logic MUST be tested independently from the UI framework.

### 2.2. Test Coverage
- The overall test coverage MUST be maintained at 85% or higher for lines, branches, and functions.
- You are not allowed to submit code that decreases the overall test coverage.

### 2.3. Test Implementation
- Test files MUST be co-located with the source files they are testing, using the `.spec.ts` suffix. (e.g., `utils.ts` and `utils.spec.ts`).
- Mock dependencies to ensure tests are isolated and fast.

---

## 3. GitHub Usage Rules (GitHub利用ルール)

### 3.1. Branch Naming Convention
- Branch names MUST follow the pattern: `type/short-description`.
- `type` can be one of: `feature`, `fix`, `refactor`, `chore`, `docs`.
- Example: `feature/user-authentication`

### 3.2. Commit Message Convention
- Commit messages MUST follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.
- Format: `<type>(<scope>): <subject>`
- Example: `feat(auth): implement password hashing with argon2`

### 3.3. Pull Request (PR) Convention
- The PR title MUST also follow the Conventional Commits format.
- The PR body MUST include a link to the issue it resolves, using the `Closes #<issue-number>` keyword.
- All PRs MUST include the Claude Code footer:
  ```
  🤖 Generated with [Claude Code](https://claude.ai/code)
  
  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

---

## 4. Claude Code Workflow Optimization (Claude Code ワークフロー最適化)

### 4.1. Efficient Task Management
- Use TodoWrite and TodoRead tools FREQUENTLY to track progress and ensure no tasks are missed.
- Break complex tasks into smaller, manageable todos with clear status tracking.
- Mark todos as completed IMMEDIATELY after finishing each task.

### 4.2. Batch Processing
- ❌ **Avoid**: Making multiple separate requests for related changes
- ✅ **Prefer**: Request comprehensive changes in a single prompt
- Example: "Set up TypeScript project with Vitest testing, ESLint, CI/CD pipeline, and initial tests"

### 4.3. Context-Aware Prompting
- Always provide sufficient context about the project structure and requirements
- Include specific file paths and expected functionality
- Example: "Add tests for src/api/users.ts including error cases and edge cases"

### 4.4. Test-Driven Development
- Request both implementation AND tests in a single prompt
- Aim for 80%+ coverage in all new code
- Example: "Implement user authentication API with JWT tokens. Include comprehensive tests."

---

## 5. CI/CD Pipeline Requirements (CI/CD パイプライン要件)

### 5.1. Test Framework Configuration
- MUST use Vitest as the primary test runner (not Jest)
- Coverage configuration MUST include all required reporters:
  ```typescript
  // vitest.config.ts
  reporter: ['text', 'json', 'json-summary', 'html']
  ```

### 5.2. GitHub Actions Setup
- CI pipeline MUST include these stages in order:
  1. Code quality checks (lint, typecheck)
  2. Unit tests with coverage
  3. Build verification
  4. Coverage reporting to PR
- Use self-hosted runners when available for better performance
- MUST set GitHub Actions permissions to "Read and write permissions" for coverage reports

### 5.3. Testable Code Structure
- All main application code MUST be exportable for testing:
  ```typescript
  export const app = express();
  export function myFunction() { /* ... */ }
  
  // Only start server when run directly
  if (require.main === module) {
    app.listen(port);
  }
  ```

### 5.4. Coverage Requirements
- Minimum 80% code coverage for all new code
- PRs MUST NOT decrease overall coverage
- Coverage reports MUST be automatically posted to PRs

---

## 6. Personal Development Optimization (個人開発最適化)

### 6.1. 完全自動化フロー
```
Issue作成 → ブランチ → 実装 → テスト → PR → 自動デプロイ → 世界配信
```

### 6.2. 技術スタック（実証済み最適解）
- **開発環境**: Express.js + TypeScript strict mode
- **本番環境**: Cloudflare Workers（グローバルエッジ）
- **テスト**: Vitest + Supertest（高速・軽量）
- **CI/CD**: GitHub Actions self-hosted runner（コスト削減）
- **品質**: 80%+ カバレッジ + 自動PR報告

### 6.3. Claude Code 最適化パターン
1. **一括処理**: 関連作業を1プロンプトで完結
2. **TodoWrite活用**: 複雑タスクの進捗管理
3. **テスト駆動**: 実装とテストを同時依頼
4. **デプロイ自動化**: CI/CD完全統合

### 6.4. プロジェクト構造（標準化）
```
src/
├── index.ts           # Express版（開発・テスト用）
├── worker.ts          # Workers版（本番用）
└── __tests__/         # 包括的テスト
.claude/              # カスタムコマンド
.github/workflows/    # 最適化CI/CD
templates/            # 再利用テンプレート
```

### 6.5. 開発コマンド（効率化済み）
- `npm run dev` - Express開発サーバー
- `npm run dev:worker` - Workers開発サーバー  
- `npm run test:coverage` - カバレッジ生成
- `npm run deploy` - 本番デプロイ
- `npm run precommit` - コミット前チェック

### 6.6. 品質基準（妥協なし）
- TypeScript strict mode + 追加厳格ルール
- ESLint エラーゼロ（自動修正込み）
- テストカバレッジ 80%+ 必須
- CI全ステージ通過必須
- デプロイ後ヘルスチェック必須

### 6.7. パフォーマンス実績
- CI pipeline: 2-3分（self-hosted効果）
- テスト実行: 10-30秒（Vitest高速化）
- ビルド: 30秒-1分（最適化設定）
- デプロイ: 30-60秒（Cloudflare高速）
- グローバル配信: 即座（エッジ展開）

### 6.8. コスト効率
- GitHub Actions: $0（self-hosted）
- Cloudflare Workers: $0-5/月（無料枠大）
- 開発効率: 3-5倍向上（自動化効果）

---

## 7. 新規プロジェクト高速スタート

### 7.1. 1分セットアップ
```bash
# テンプレート使用
./templates/project-setup-optimized.sh my-new-project

# Claude Code で効率化
/setup-fullstack
```

### 7.2. 即座に使えるコマンド
- `/check-ci` - CI確認・修正自動化
- `/sync-main` - ブランチ同期
- `/deploy-test` - デプロイ動作確認
- `/setup-cloudflare` - Workers追加

### 7.3. 実証済み効率化
- 初期セットアップ: 10分 → 1分
- 機能追加: 半日 → 1-2時間  
- デプロイ: 手動30分 → 自動3分
- 品質担保: 手動チェック → 自動化