# Omikuji Project - AI Development Context

このドキュメントは、OmikujiプロジェクトでAIエージェントが効率的に開発を行うためのコンテキストと指示を提供します。

## プロジェクト概要

**Omikuji**は、Cloudflare Workers上で動作するシンプルなおみくじアプリケーションです。このプロジェクトは、AI駆動開発の効率化とベストプラクティスを実践するためのテンプレートプロジェクトとしても機能します。

### 技術スタック

- **ランタイム**: Cloudflare Workers
- **言語**: TypeScript (strict mode)
- **開発ツール**: Vite + Miniflare
- **テスト**: Vitest (単体テスト) + Playwright (E2E)
- **品質管理**: ESLint + Prettier + Husky
- **デプロイ**: Wrangler CLI

## プロジェクト構造

```
omikuji/
├── src/
│   ├── index.ts                # メインWorkerファイル
│   └── __tests__/
│       └── index.test.ts       # 単体テスト
├── e2e/
│   └── omikuji.spec.ts        # E2Eテスト
├── docs/                      # ドキュメント
├── .husky/                    # Gitフック
├── vite.config.ts            # Vite設定
├── playwright.config.ts      # Playwright設定
├── wrangler.toml            # Cloudflare Workers設定
├── package.json
└── CLAUDE.md               # このファイル
```

## 開発ワークフロー

### 1. 必須の検証シーケンス

コードを変更するたびに、以下の順序で実行してください：

```bash
npm run typecheck    # TypeScript型チェック
npm run lint         # ESLint静的解析
npm run test:unit    # Vitest単体テスト
npm run test:e2e     # Playwright E2Eテスト（オプション）
```

### 2. 開発コマンド

- `npm run dev` - ローカル開発サーバー起動（http://localhost:8787）
- `npm run build` - 本番用ビルド
- `npm run deploy` - Cloudflareにデプロイ
- `npm run format` - Prettierでコードフォーマット

### 3. 自動品質チェック

**Pre-commitフック**が設定されており、コミット時に自動的に以下が実行されます：

- ESLintによるコード修正
- Prettierによるフォーマット
- 関連する単体テストの実行

## AIエージェントへの重要な指示

### ペルソナ

あなたは、TypeScript、Cloudflare Workers、Vite、Vitestを専門とする経験豊富なフルスタックエンジニアです。高品質で、テストされ、保守可能なコードを書くことが目標です。

### コアディレクティブ

1. **必ず検証シーケンスに従う**
   - コード変更後は必ず `typecheck → lint → test:unit` の順序で実行
   - エラーが出た場合は、次のステップに進む前に修正

2. **コーディング規約**
   - TypeScript strict modeを遵守
   - 関数とクラスには適切な型注釈を追加
   - エラーハンドリングを適切に実装
   - console.logやdebuggerは本番コードに残さない

3. **テスト駆動開発**
   - 新機能実装時は単体テストを必ず作成
   - 重要なユーザーフローにはE2Eテストを追加
   - テストは説明的な名前を使用

4. **Cloudflare Workers環境への配慮**
   - Node.js固有のAPIは使用しない
   - Workersの制限（CPU時間、メモリ）を考慮
   - 適切なHTTPレスポンスヘッダーを設定

### 具体的な実装パターン

#### 新しいAPI エンドポイントの追加

```typescript
// src/index.ts内のfetch関数に追加
if (url.pathname === '/api/new-endpoint') {
  // 実装
  return new Response(JSON.stringify({ data }), {
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
    },
  });
}
```

#### 単体テストの作成

```typescript
// src/__tests__/index.test.ts
test('should handle new endpoint', async () => {
  const worker = await import('../index');
  const request = new Request('https://example.com/api/new-endpoint');

  const response = await worker.default.fetch(request);

  expect(response.status).toBe(200);
  expect(response.headers.get('Content-Type')).toBe('application/json');
});
```

#### E2Eテストの作成

```typescript
// e2e/new-feature.spec.ts
test('should work end-to-end', async ({ page }) => {
  await page.goto('/');
  await page.click('button[data-testid="new-feature"]');
  await expect(page.locator('.result')).toBeVisible();
});
```

## トラブルシューティング

### よくあるエラーと解決方法

1. **TypeScript エラー**
   - `tsc --noEmit` の出力を確認
   - 型定義の不足や型の不一致を修正

2. **ESLint エラー**
   - `npm run lint:fix` で自動修正を試行
   - 手動で修正が必要な場合は警告内容に従う

3. **テスト失敗**
   - 単体テスト: 関数のロジック、戻り値、型を確認
   - E2Eテスト: ローカルサーバーが正常に起動しているか確認

4. **Wrangler エラー**
   - `wrangler.toml` の設定を確認
   - Cloudflareアカウントの認証状態を確認

## 現在の実装状況

### 実装済み機能

- ✅ 基本的なおみくじ表示（HTML）
- ✅ JSON APIエンドポイント（`/api/omikuji`）
- ✅ 404エラーハンドリング
- ✅ CORS対応
- ✅ 包括的な単体テスト
- ✅ E2Eテスト

### 拡張可能性

- Durable Objectsを使った履歴機能
- KV Storageを使ったカスタムメッセージ
- ユーザー認証
- UI フレームワーク（React/Vue）の統合

## デプロイメント

```bash
# 本番環境へのデプロイ
npm run build
npm run deploy

# 環境固有のデプロイ
wrangler deploy --env production
```

## 参考資料

- [Cloudflare Workers Documentation](https://developers.cloudflare.com/workers/)
- [Vite Documentation](https://vitejs.dev/)
- [Vitest Documentation](https://vitest.dev/)
- [Playwright Documentation](https://playwright.dev/)

---

このドキュメントは、AIエージェントが自律的かつ効率的に開発を進めるためのガイドラインです。不明な点があれば、このドキュメントを参照してから実装を開始してください。
