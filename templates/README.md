# AI駆動開発最適化テンプレート

このディレクトリには、AI駆動開発に最適化されたプロジェクトテンプレートとツールが含まれています。  
AUTOMATION_GUIDELINE.md と LESSONS_LEARNED.md の知見を基に、自己修正型AI環境を構築します。

## 🤖 AI駆動開発の特徴

- **4層検証システム**: 静的解析 → 単体テスト → E2E → 品質ゲート
- **自己修正型環境**: AIエージェントが自律的に品質チェック
- **統一アーキテクチャ**: Cloudflare Workers単一実装
- **高速フィードバック**: Vite + Miniflare + Vitest統合

## 🚀 クイックスタート

### 新規プロジェクト作成（推奨）

```bash
# AI駆動開発最適化済みプロジェクト
./ai-driven-cloudflare-setup.sh my-ai-project
cd my-ai-project
npm install
npm run dev
```

## 📁 ファイル構成

### 🔧 セットアップスクリプト

#### `ai-driven-cloudflare-setup.sh` ⭐ **推奨**

**AI駆動開発最適化 Cloudflare Workers プロジェクトセットアップ**

```bash
# 使用例
./ai-driven-cloudflare-setup.sh my-ai-project
```

**自動設定内容:**

- ✅ 4層検証システム（TypeScript + ESLint + Vitest + Playwright）
- ✅ 自己修正型AI環境（Husky + lint-staged）
- ✅ 統一Cloudflare Workersアーキテクチャ
- ✅ 高速フィードバックループ（Vite + Miniflare）
- ✅ CI/CD with E2E Testing
- ✅ AI Agent最適化（CLAUDE.md）

**技術スタック:**

- Cloudflare Workers + TypeScript + Vite
- Vitest (単体テスト) + Playwright (E2E)
- ESLint (静的解析) + Prettier (フォーマット)
- Husky + lint-staged (品質ゲート)

### ⚙️ GitHub Actions テンプレート

#### `github-workflows-ci.yml` ⭐ **AI駆動開発対応**

**4層検証システム実装 CI/CD パイプライン**

**特徴:**

- Layer 1: 静的解析（TypeScript + ESLint + Prettier）
- Layer 2: 単体テスト（Vitest）
- Layer 3: E2Eテスト（Playwright）
- Layer 4: 品質ゲート（Pre-commit hooks）
- Cloudflare Workers 統一アーキテクチャ
- CI環境最適化（ubuntu-latest + chromiumのみ）

**使用方法:**

```bash
cp templates/github-workflows-ci.yml .github/workflows/ci.yml
```

#### `github-actions-optimized.yml`

**従来版CI/CDテンプレート（参考用）**

## 🏗 AI駆動開発のアーキテクチャ

### 4層検証システム

```
第1層: 静的解析 (TypeScript + ESLint + Prettier)
    ↓ 即座のフィードバック（IDE内でリアルタイム）
第2層: 単体テスト (Vitest)
    ↓ 高速なロジック検証（200ms以下）
第3層: E2Eテスト (Playwright)
    ↓ ユーザー体験の保証
第4層: 品質ゲート (Husky + lint-staged)
    ↓ コミット時の自動品質保証
```

### AIエージェントの検証シーケンス

```bash
# 必須の検証シーケンス（AIは必ずこの順序で実行）
npm run typecheck    # 型チェック
npm run lint         # コード品質
npm run test:unit    # 単体テスト
npm run test:e2e     # E2E（必要に応じて）
```

## 🎯 AUTOMATION_GUIDELINE.md の実装

このテンプレートは、AUTOMATION_GUIDELINE.md で定義された「自律型コーダーハンドブック」の原則を実装しています：

### 感覚システムの構築

- **認識層**: TypeScript + ESLint（構造と品質の推論）
- **行動層**: Vitest + Playwright（振る舞いと体験の検証）
- **門番層**: Husky + lint-staged（品質ゲート）

### AIへの効果的な指示方法

- CLAUDE.md による明確なコンテキスト提供
- 検証シーケンスの標準化
- エラータイプの明確な分離

## 📈 LESSONS_LEARNED.md からの知見

このテンプレートには、実際の開発で得られた以下の知見が反映されています：

### アーキテクチャの統一

- Express版を削除し、Cloudflare Workers単一実装に統一
- AIエージェントの混乱を防ぐ一貫した構造

### CI/CD環境の最適化

- ubuntu-latest ランナーの使用
- Playwright の軽量化（chromiumのみ）
- 段階的品質チェック

### データ整合性の維持

- テストデータと実装の厳密な一致
- UIテストと実際のHTML構造の整合性

### ツールの統合効果

- Vite による開発環境の統一
- 設定ファイルの集約

## 🛠 使用方法詳細

### 1. 新規プロジェクト作成

```bash
# このリポジトリをクローン
git clone https://github.com/he-be/omikuji.git
cd omikuji/templates

# AI駆動プロジェクト作成
./ai-driven-cloudflare-setup.sh my-ai-project
cd my-ai-project

# 依存関係インストール
npm install

# 初期コミット
git add . && git commit -m "Initial AI-driven setup"
```

### 2. GitHub 連携

```bash
# リポジトリ作成・プッシュ
gh repo create my-ai-project --public --source=. --remote=origin --push

# Cloudflare Secrets 設定
gh secret set CLOUDFLARE_API_TOKEN
gh secret set CLOUDFLARE_ACCOUNT_ID
```

### 3. AI駆動開発開始

```bash
# 開発サーバー起動
npm run dev          # Cloudflare Workers + Miniflare

# AI検証シーケンス実行
npm run typecheck    # 第1層: 静的解析
npm run lint         # 第1層: コード品質
npm run test:unit    # 第2層: 単体テスト
npm run test:e2e     # 第3層: E2E（必要に応じて）

# デプロイ（自動）
git push origin main
```

## 🤖 AIエージェント向けガイドライン

### 必須の検証シーケンス

AIエージェントは必ず以下の順序で検証を実行してください：

1. `npm run typecheck` - 型エラーの検出
2. `npm run lint` - コード品質の確認
3. `npm run test:unit` - ロジックの検証
4. `npm run test:e2e` - 統合の確認（必要に応じて）

### エラー対応指針

- **静的解析エラー** → 構文・型の問題
- **単体テストエラー** → ロジックの問題
- **E2Eテストエラー** → 統合・UIの問題

### データ整合性の維持

- テストデータは実装と厳密に一致させる
- UIテストは実際のHTML構造を反映
- 共通定数は単一箇所で管理

## 📊 効率化実績

### Before（従来の手動セットアップ）

- 初期設定: 30分-1時間
- CI/CD設定: 1-2時間
- テスト環境構築: 1時間
- **合計: 2.5-4時間**

### After（AI駆動テンプレート）

- セットアップ: 1分
- 設定完了: 5分
- 検証システム: 自動
- **合計: 10分未満**

### AI駆動開発の効果

- **機能追加**: 半日 → 1-2時間
- **バグ修正**: 数時間 → 10-30分
- **デプロイ**: 手動30分 → 自動3分
- **品質保証**: 手動チェック → 自動検証

## 🎯 新しい開発体験

このテンプレートにより以下が実現されます：

### 🚀 AI First Development

- 1分でプロジェクト開始
- 自動品質チェック
- 自己修正型環境

### 🛡 品質の民主化

- 妥協なき品質基準
- 全自動テスト・カバレッジ
- CI/CD完全統合

### 💡 効率的な学習サイクル

- CLAUDE.md による明確なコンテキスト
- 即座のフィードバック
- 継続的な改善

**🤖 Ready for AI-Driven Development! 🚀**

---

_このテンプレートは AUTOMATION_GUIDELINE.md の「自律型コーダーハンドブック」と LESSONS_LEARNED.md の実戦知見に基づいて設計されています。_
