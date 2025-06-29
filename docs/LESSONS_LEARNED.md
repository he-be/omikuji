# Lessons Learned: AI駆動開発とCloudflare Workers統一アーキテクチャへの移行

## 概要

このドキュメントは、OmikujiプロジェクトをExpress版とCloudflare Workers版の混在アーキテクチャから、統一されたCloudflare Workers環境に移行する過程で得られた重要な知見をまとめています。

## 主要な知見

### 1. アーキテクチャの統一の重要性

#### 問題

- Express版とCloudflare Workers版の2つの実装が共存
- 異なる依存関係、テスト方法、デプロイプロセス
- AIエージェントが混乱しやすい複雑な構造

#### 解決策

- 単一のCloudflare Workers実装に統一
- 一貫したローカル開発環境（Miniflare）
- 統一されたCI/CDパイプライン

#### 教訓

> **AIエージェントは単純で一貫したアーキテクチャを好む。複数の実装パスは開発効率を著しく低下させる。**

### 2. 自己修正型開発環境の構築

#### 実装した4層検証システム

```
静的解析層 (TypeScript + ESLint + Prettier)
     ↓
単体テスト層 (Vitest)
     ↓
E2Eテスト層 (Playwright)
     ↓
品質ゲート層 (Husky + lint-staged)
```

#### 各層の役割と効果

1. **静的解析層**:
   - 即座のフィードバック（IDE内でリアルタイム）
   - 型エラー、構文エラー、スタイル違反を早期発見

2. **単体テスト層**:
   - 高速なロジック検証（200ms以下）
   - 関数レベルでの詳細なエラー情報

3. **E2Eテスト層**:
   - ユーザー体験の保証
   - 統合部分での問題発見

4. **品質ゲート層**:
   - コミット時の自動品質保証
   - ブロークンコードの本流混入防止

#### 教訓

> **各層は異なる種類のエラーを捕捉する。すべての層が機能して初めて、AIエージェントが自律的に高品質なコードを生成できる。**

### 3. CI/CD環境でのPlaywright実行の課題と解決

#### 遭遇した問題

1. **依存関係の問題**:

   ```bash
   # 失敗: システム依存関係でsudo権限が必要
   npx playwright install --with-deps chromium

   # 成功: ブラウザのみをインストール
   npx playwright install chromium
   ```

2. **環境差異の問題**:
   - self-hostedランナーでの依存関係不足
   - ubuntu-latestランナーでの安定した動作

#### 解決策

1. **CI環境の最適化**:

   ```typescript
   // playwright.config.ts
   projects: [
     {
       name: 'chromium',
       use: { ...devices['Desktop Chrome'] },
     },
     // CI環境では軽量化のためchromiumのみを使用
     ...(process.env.CI
       ? []
       : [
           /* firefox, webkit */
         ]),
   ];
   ```

2. **環境固有の設定**:
   ```typescript
   use: {
     // CI環境での追加設定
     ...(process.env.CI && {
       video: 'retain-on-failure',
       headless: true,
     }),
   }
   ```

#### 教訓

> **CI環境では軽量化と安定性を優先する。ローカル開発環境とは異なる最適化が必要。**

### 4. テストデータの一貫性の重要性

#### 発生した問題

```typescript
// src/index.ts の実際のデータ
export const omikujiResults = ['大凶', '凶', '小吉', '吉', '大吉'];

// E2Eテストでの期待値（間違い）
expect(resultText).toMatch(/^(大吉|中吉|小吉|吉|末吉)$/);
```

#### 問題の原因

- ソースコードとテストコードの乖離
- データの定義が複数箇所に散在
- 手動での同期が必要

#### 解決策

1. **共通データソースの使用**:

   ```typescript
   // 単体テストでは実際のデータを使用
   expect(omikujiResults).toContain(result);

   // E2Eテストでも同じデータを期待
   expect(resultText).toMatch(/^(大凶|凶|小吉|吉|大吉)$/);
   ```

2. **データ駆動テストの採用検討**:
   ```typescript
   omikujiResults.forEach((result) => {
     test(`should handle ${result} result`, async () => {
       // テストロジック
     });
   });
   ```

#### 教訓

> **テストデータは実装と厳密に一致させる。データの定義は単一箇所にまとめ、テストではそれを参照する。**

### 5. HTML要素とテストセレクターの整合性

#### 発生した問題

```html
<!-- 実際のHTML -->
<a href="/" class="reload-button">もう一度引く</a>

<!-- テストの期待（間違い） -->
await page.click('button:has-text("もう一度引く")');
```

#### 解決策

```typescript
// 正しいセレクター
await page.click('a:has-text("もう一度引く")');
await expect(tryAgainLink).toHaveAttribute('href', '/');
```

#### 教訓

> **E2Eテストは実際のHTML実装を正確に反映する必要がある。UIの変更時はテストも同時に更新する。**

### 6. Viteによる開発環境の統一効果

#### 導入前の問題

- Vitest用とTypeScript用の設定が分離
- ビルドプロセスが複雑
- 開発サーバーとテスト環境の不整合

#### 導入後の改善

```typescript
// vite.config.ts で統一管理
export default defineConfig(
  defineVitestConfig({
    test: {
      /* Vitestの設定 */
    },
    build: {
      /* Viteビルドの設定 */
    },
    // 共通設定
  })
);
```

#### 効果

- 設定ファイルの統一（vitest.config.ts削除）
- 高速なHMR（Hot Module Replacement）
- TypeScript + Vitestのシームレスな統合

#### 教訓

> **ツールの統合により、設定の複雑さを削減し、開発体験を向上させることができる。**

### 7. Pre-commitフックによる品質保証の自動化

#### 実装したフロー

```bash
git commit → husky → lint-staged → [eslint --fix, prettier --write, vitest related --run]
```

#### 効果的だった設定

```json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "vitest related --run" // 関連テストのみ実行
    ]
  }
}
```

#### 教訓

> **Pre-commitフックは軽量であることが重要。関連テストのみ実行することで、コミット時間を短縮できる。**

### 8. GitHub ActionsでのCloudflare Workers CI/CD

#### 学んだベストプラクティス

1. **段階的な検証**:

   ```yaml
   # 静的解析 → 単体テスト → E2E → ビルド の順序
   - name: Run typecheck
   - name: Run lint
   - name: Run unit tests
   - name: Run E2E tests
   - name: Build project
   ```

2. **環境の使い分け**:
   - ubuntu-latest: 標準的なCI/CD
   - self-hosted: 特別な要件がある場合のみ

3. **Cloudflareとの統合**:
   ```yaml
   # Wranglerデプロイ
   - name: Deploy to Cloudflare Workers
     run: npm run deploy
     env:
       CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
   ```

#### 教訓

> **CI/CDは本番環境を忠実に再現しつつ、実行時間を最適化する必要がある。**

## AIエージェント向けの推奨事項

### 1. プロジェクト構造の理解

- **CLAUDE.md**を最初に確認
- 技術スタックと検証シーケンスを把握
- 設定ファイルの役割を理解

### 2. 開発フロー

```bash
# 必須の検証シーケンス
npm run typecheck  # 型チェック
npm run lint       # コード品質
npm run test:unit  # 単体テスト
npm run test:e2e   # E2E（必要に応じて）
```

### 3. エラー対応

- 各層のエラーは異なる種類の問題を示す
- 静的解析エラー → 構文・型の問題
- 単体テストエラー → ロジックの問題
- E2Eテストエラー → 統合・UI の問題

### 4. データ整合性の維持

- テストデータは実装と一致させる
- UIテストは実際のHTML構造を反映
- 共通定数は単一箇所で管理

## 結論

このプロジェクトの移行を通じて、**AI駆動開発における自己修正型環境の重要性**が明確になりました。各ツールが独立して動作するのではなく、統合されたシステムとして機能することで、AIエージェントが自律的に高品質なコードを生成できるようになります。

特に重要なのは：

1. **アーキテクチャの統一**による複雑性の削減
2. **多層的な検証システム**による品質保証
3. **実装とテストの厳密な整合性**
4. **CI/CD環境の適切な最適化**

これらの知見は、今後の新規プロジェクトや既存プロジェクトの改善において、再利用可能な貴重な資産となります。

---

_このドキュメントは、実際の開発過程で遭遇した問題と解決策を基に作成されており、今後のAI駆動開発プロジェクトの参考資料として活用できます。_
