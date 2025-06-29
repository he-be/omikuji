# Omikujiプロジェクト アップグレード計画

## 概要

このドキュメントは、OmikujiプロジェクトをAUTOMATION_GUIDELINE.mdの理念に基づいて、AI駆動開発に最適化された構成にアップグレードする計画を記載しています。

## アップグレードの目的

1. **統一されたアーキテクチャ**: Express版を廃止し、Cloudflare Workers版に統一
2. **自己修正型開発環境**: AIエージェントが自律的にコード品質を検証できる環境の構築
3. **高速なフィードバックループ**: Vite + Miniflareによる即座のフィードバック
4. **完全な品質保証**: 静的解析からE2Eテストまでの多層的な検証システム

## アーキテクチャの変更

### 現在の構成
- Express.js版とCloudflare Workers版の2つの実装が混在
- ESLintが未設定（`npm run lint`は形骸化）
- E2Eテストフレームワークなし
- Pre-commitフックなし

### 目標の構成
```
Cloudflare Workers (統一実装)
    ├── Vite (開発サーバー & ビルドツール)
    ├── Miniflare (ローカルWorkers環境)
    ├── TypeScript (型安全性)
    ├── ESLint + Prettier (コード品質)
    ├── Vitest (単体テスト)
    ├── Playwright (E2Eテスト)
    └── Husky + lint-staged (品質ゲート)
```

## 実装フェーズ

### フェーズ1: 基盤の統一（優先度: 高）

1. **Express版の削除**
   - `src/index.ts`の削除
   - `src/__tests__/index.test.ts`の削除
   - Express関連の依存関係の削除
   - package.jsonスクリプトの整理

2. **Vite環境の構築**
   - Viteの導入と設定
   - 開発サーバーの設定（Miniflareとの統合）
   - ビルド設定の最適化

3. **ESLint/Prettierの導入**
   - `eslint.config.js`の作成（フラット設定）
   - TypeScript ESLintプラグインの設定
   - Prettierとの統合
   - 実効性のある`npm run lint`コマンドの実装

### フェーズ2: 品質保証の強化（優先度: 高）

4. **Playwright E2Eテストの実装**
   - `playwright.config.ts`の作成
   - Miniflareとの連携設定
   - 基本的なE2Eテストの作成
   - `npm run test:e2e`コマンドの追加

5. **Pre-commitフックの設定**
   - Huskyの導入
   - lint-stagedの設定
   - 自動品質チェックの実装

6. **CLAUDE.mdの作成**
   - プロジェクト固有のコンテキスト
   - 開発ルールと規約
   - AIエージェント向けの指示

### フェーズ3: 機能拡張（優先度: 中）

7. **Cloudflareエッジ機能の実装例**
   - Durable Objectsを使用した履歴管理
   - KV Storageを使用したメッセージ管理
   - ステートフルな機能のデモ実装

8. **CI/CDパイプラインの最適化**
   - GitHub Actionsワークフローの改善
   - 全テストスイートの自動実行
   - デプロイメントの自動化

### フェーズ4: 将来の拡張（優先度: 低）

9. **フロントエンドフレームワークの検討**
   - React/Vueの導入評価
   - コンポーネントベースのUI構築

## 技術スタックの詳細

### 開発環境
- **Vite**: 高速な開発サーバーとビルドツール
- **Miniflare**: Cloudflare Workers環境のローカルシミュレーター
- **Wrangler**: Cloudflare CLIツール

### 品質管理
- **TypeScript**: `strict: true`で厳格な型チェック
- **ESLint**: `eslint:recommended` + `typescript-eslint`
- **Prettier**: コードフォーマットの統一
- **Vitest**: 高速な単体テスト実行
- **Playwright**: クロスブラウザE2Eテスト

### デプロイメント
- **Cloudflare Workers**: グローバルエッジでの実行
- **GitHub Actions**: 自動デプロイパイプライン

## 期待される成果

1. **AIエージェントの効率向上**
   - 単一の実装パスによる理解の簡易化
   - 自動検証による自己修正能力の向上
   - 明確なフィードバックループ

2. **開発体験の改善**
   - 高速な開発サイクル
   - 一貫性のあるコード品質
   - 信頼性の高いテストカバレッジ

3. **テンプレートとしての価値**
   - 最新のベストプラクティス
   - 実践的なCloudflare機能の例
   - AI駆動開発のリファレンス実装

## 成功基準

- [ ] すべてのコマンドが「静的解析→単体テスト→E2Eテスト」のシーケンスで実行可能
- [ ] `git commit`時に自動的に品質チェックが実行される
- [ ] AIエージェントがCLAUDE.mdを参照して自律的に開発できる
- [ ] ローカル環境と本番環境の挙動が一致する

## タイムライン

1. **Week 1**: フェーズ1の完了（基盤の統一）
2. **Week 2**: フェーズ2の完了（品質保証の強化）
3. **Week 3**: フェーズ3の開始（機能拡張）
4. **継続的**: フィードバックに基づく改善

---

このアップグレード計画により、Omikujiプロジェクトは真にAIファーストな開発環境のテンプレートとして生まれ変わります。