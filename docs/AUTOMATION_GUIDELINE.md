自律型コーダーハンドブック：自己修正AIの構築と指示に関する最新ウェブ開発ガイド




序論：AIが監督するワークフローの夜明け


AI駆動開発への移行は、開発者を置き換えることではなく、監督者としての役割へと引き上げるものです。生産性における最大の飛躍は、AIが自らの誤りを自己修正できる環境を構築することから生まれます。これは、単に要件をAIに与えるだけでは達成できません。
このプロセスは、自動運転車の開発に例えることができます。目的地（「何を」作るか）を指示するのは簡単ですが、真の技術的挑戦は、車に搭載されたセンサー（LIDAR、カメラなど）が環境を認識し、その感覚入力に基づいてプロセッサが反応する（「どのように」実現するか）能力を与えることにあります。本稿で構築する開発環境は、AIコーディングエージェントにとっての、この感覚・処理システムそのものです。
このハンドブックの目的は、最新かつプロフェッショナルなツールチェーンを用いてこの「感覚システム」を構築するための包括的なステップバイステップガイドを提供し、その環境内でAIエージェントに効果的に「言語」を話しかけ、指示を出す方法を解説することにあります。


第1部：自己修正型開発環境の柱


このセクションでは、品質管理の基盤となる階層を確立します。これらのツールは個別のユーティリティとしてではなく、統合された多層的な「セーフティネット」として提示されます。


第1章：静的解析 - 第一次防衛線


静的解析は、コードを実行する前に問題を検出する最も迅速かつ低コストなフィードバックループを形成します。これはAIエージェントの感覚システムの「認識」層として機能し、コードの構造と品質について推論する能力を与えます。


1.1 TypeScript：コードの設計図


TypeScriptは、JavaScriptに静的型付けの概念を追加した上位互換（スーパーセット）言語です 1。これは全く別の言語ではなく、より堅牢なコードを書くための拡張機能と位置づけられています。
AIエージェントにとってTypeScriptが不可欠な理由は、人間と同様に、AIも単純な間違い（例：文字列が期待される箇所に数値を渡す）を犯す可能性があるためです。TypeScriptは、これらの型エラーをコードが実行される前、すなわちコンパイル段階で検出します 2。これは最も速く、最もコストの低いフィードバックループです。
AIへの指示において重要なのは、interfacesやtypesといった型定義を「契約」として活用することです 3。AIに対しては、「それらを使用する関数を実装する前に、まずデータ構造とインターフェースを定義せよ」と指示することが効果的です。エージェントが自らのコードの妥当性をTypeScriptコンパイラに「尋ねる」ための主要なメカニズムは、
tsc --noEmitコマンドです 4。このコマンドはJavaScriptファイルを生成せずに型チェックのみを実行するため、AIの自己検証プロセスの第一歩となります。


1.2 ESLint：コード品質とスタイルの守護神


ESLintは、JavaScriptコード内の問題のあるパターンを特定し、一貫したコーディングスタイルを強制するための静的コード解析ツールです 7。その役割は型エラーの検出を超え、未使用の変数、潜在的なバグ、スタイルの一貫性の欠如といった問題にまで及びます。
AIは構文的に正しくても、スタイルが一貫していなかったり、非慣習的なコードを生成することがあります。ESLintは、生成されたコードがチームの基準に準拠していることを保証し、人間とAIの協業において不可欠な可読性と保守性を高めます 9。設定は
eslint.config.js（または旧式の.eslintrc.cjs）で行い、推奨ルールセット（eslint:recommended）やTypeScript固有のルール（typescript-eslint）を統合することで、AIのための設定可能な「ルールブック」を提供します 10。エージェントがこのルールブックに対してコードを検証するためのコマンドが
npm run lintです。


第2章：自動テスト - あらゆるレベルでの正当性の検証


静的解析がコードの構造を検証するのに対し、自動テストはコードの振る舞いを検証します。このテスト層は、AIに「ロジックは正しいか」「ユーザー体験は正しいか」という行動的・体験的なフィードバックを提供します。


2.1 Vitest：高速な単体・結合テスト


Vitestは、Viteを基盤とした最新の高速テストフレームワークです 13。主に「単体テスト」（個別の関数など、コードの小さな断片を隔離してテストする）や「コンポーネントテスト」（個別のUIコンポーネントをテストする）に使用されます。
AIは、型が完全に正しいにもかかわらず、誤った結果を生み出すコードを書く可能性があります。Vitestは、例えばadd(2, 2)が実際に4を返すことを検証します。その実行速度は、AIによる迅速なイテレーションサイクルにおいて大きな利点となります 13。テストの記述には
describe、test（またはit）、expectといったAPIが用いられます。AIが個々のコード部品の正しさを検証するためのコマンドがnpm run test:unitです。


2.2 Playwright：エンドツーエンド（E2E）の完全性を保証


Playwrightは、Microsoftが開発した強力なブラウザ自動化ツールで、E2Eテストに使用されます 15。Chromium、Firefox、WebKitといった主要なブラウザエンジン上で、実際のユーザー操作をシミュレートします。
これは究極の検証手段です。AIが作成したコードの各ユニットがテストに合格しても、アプリケーション全体としては機能しない（例：ボタンをクリックしてもバックエンドの正しい処理が呼び出されない）可能性があります。Playwrightは、フロントエンドからバックエンドまでシステム全体をチェックし、ユーザーフローが期待通りに機能することを確認します 16。クロスブラウザ対応や、要素が表示されるまで自動で待機する機能、さらにはユーザー操作を記録してテストスクリプトを自動生成する
codegen機能は、テスト作成を強力に支援します 16。AIがユーザー視点でのアプリケーション全体の動作を確認するためのコマンドが
npm run test:e2eです。
この階層的なテスト戦略は、効率的なデバッグに不可欠です。AIが機能を生成した後、まず単体テストを実行します。ここで失敗すれば、エラーは特定の関数やコンポーネントに限定され、AIは非常に小さな範囲にデバッグの労力を集中できます。単体テストが通れば、次にE2Eテストを実行します。これが失敗した場合、問題は個々のコンポーネントではなく、それらの統合にある可能性が高いと判断できます。このデバッグの「漏斗」構造により、AIは単一関数の単純なロジックバグを見つけるために、時間のかかるE2Eテストを実行する無駄を省けます。したがって、AIには「静的解析 → 単体テスト → E2Eテスト」というシーケンスに従うよう指示することが極めて重要です。


第3章：ワークフローの自動化 - 門番




3.1 Huskyとlint-stagedによるPre-commitフック


Gitフックとは、Gitのライフサイクルの特定の時点で自動的に実行されるスクリプトです 19。
pre-commitフックは、コミットが確定する直前に実行されます。HuskyはこのGitフックの管理を容易にするツールであり 20、
lint-stagedはコミットのためにステージングされたファイルのみを対象にスクリプトを実行するツールです 23。
これは、究極の自動化された品質ゲートです。これまでのすべてのチェック（typecheck、lint、test）を、単一の、そして譲れないステップに統合します。いずれかのチェックが失敗すると、コミットは自動的に中断されます 19。これにより、AI（または人間）が壊れたコードをバージョン履歴に混入させることを完全に防ぎます。設定は、
huskyで.husky/pre-commitファイルを作成し、package.json内でlint-stagedに一連のチェックを実行させるよう構成します 27。


表：自律型エージェントの感覚システム


以下の表は、我々が構築する多層的な「セーフティネット」を視覚化したものです。これは単なるツールの寄せ集めではなく、各層が特定の目的を持ち、異なる種類のエラーを捕捉する構造化されたシステムであることを示しています。このメンタルモデルは、AIへの指示方法を理解する上で極めて重要です。


層
	ツール
	コマンド
	目的
	検出されるエラーの種類
	フィードバック速度
	1. 静的
	TypeScript, ESLint
	tsc --noEmit, eslint
	コードの妥当性とスタイル
	型エラー、構文エラー、スタイル違反
	即時（IDE内）/ 非常に高速（CLI）
	2. 単体
	Vitest
	npm run test:unit
	ロジックの正当性
	ビジネスロジックの欠陥、計算間違い
	高速
	3. E2E
	Playwright
	npm run test:e2e
	ユーザーフローの完全性
	統合の失敗、UIバグ、リグレッション
	中速
	4. ゲート
	Husky, lint-staged
	git commit
	リグレッションの防止
	上記のすべて
	コミット前
	

第2部：エッジでの最新アプリケーションの設計


このセクションでは、特定の技術スタックを選択した背景にある戦略的な理由を解説します。この選択は、「ローカルファースト、本番環境ミラーリング」という開発哲学に基づいています。これは、自律的なAIエージェントにとって、「自分のマシンでは動く」という問題を最小限に抑えるために極めて重要です。


第4章：開発・ビルドエンジン - Vite


Vite（フランス語で「速い」を意味する）は、Vue.jsの作者であるEvan You氏によって、Webpackのような従来のビルドツールの遅い起動時間や更新時間を解決するために開発されました 30。その速度の秘訣は、開発中にブラウザのネイティブESモジュールを活用することにあります。これにより、アプリケーション全体を事前にバンドルする必要がなく、ファイルが要求された時点でオンデマンドに処理されます 31。AIエージェントにとって、Viteの高速なホットモジュールリプレースメント（HMR）とVitestとの統合 13 は、非常に迅速なフィードバックループを生み出します。本番環境向けには、ViteはRollupを使用して高度に最適化されたバンドルを作成します 31。


第5章：デプロイターゲット - Cloudflareエコシステム


AIエージェントは、ローカルのNode.js環境と本番のWorkersランタイムとの間の環境差にうまく対処できません。Cloudflareスタックには、標準的なNode.js環境には存在しない独自のAPIやプリミティブ（Durable Objectsなど）があります 33。この問題を解決するために、ローカルでCloudflare環境をシミュレートする
Miniflareが開発されました 34。この忠実度の高いローカル環境は、信頼性の高い自律開発の前提条件です。


5.1 Cloudflare Workers：エッジでのサーバーレス


Cloudflare Workersは、Cloudflareのグローバルなデータセンターネットワーク上で、エンドユーザーに近い場所で直接JavaScript（や他の言語）を実行するためのプラットフォームです 35。これにより、中央のオリジンサーバーという概念がなくなり、非常に低いレイテンシーと高いパフォーマンスが実現します 38。


5.2 Durable Objects：ステート問題を解決


従来のサーバーレス関数はステートレス（状態を持たない）であるため、チャットルームや共同編集ドキュメントのようなアプリケーションの構築が困難でした。Durable Objectsは、この問題を解決するCloudflare独自のプリミティブです。これは、強力な一貫性を持つステートフルな「アクター」を提供します 33。各Durable Objectは一意のIDを持ち、データとコードを保持できるため、特定のエンティティ（例：チャットルーム、ユーザーセッション）のためのミニサーバーとして機能します 40。これは、エッジ上で複雑でインタラクティブなアプリケーションを構築するための鍵となる技術です。


5.3 WranglerとMiniflare：ローカルとグローバルの架け橋


* Wrangler: Cloudflare Workersプロジェクトの作成、テスト、デプロイといったライフサイクル全体を管理するための公式CLIツールです 42。AIには、
wrangler deploy（または対応するnpmスクリプト）を使用するよう指示する必要があります。
* Miniflare: Workers環境に不可欠なローカルシミュレーターです 34。これは単なるサーバーではなく、Workersランタイムの高忠実度なオープンソース実装であり、KV、R2、そして決定的に重要なDurable Objectsのモックも含まれています 34。Miniflareがなければ、Durable ObjectsのようなCloudflare固有のバインディングに依存するコードをテストすることは不可能です。これにより、AIはローカルでテストを実行し、それが本番環境でも同様に動作するという高い信頼性を得ることができます 44。


第3部：設計図 - フルスタックツールチェーンの統合


このパートでは、すぐに利用可能な設定ファイルを提供し、それらがどのように連携するかを具体的に解説します。


第6章：プロジェクトの初期化と設定




6.1 package.jsonのマスタープラン


AIエージェントの「コントロールパネル」となるscriptsセクションを定義します。これにより、すべてのツールを協調させることができます。


JSON




"scripts": {
 "dev": "wrangler dev src/index.ts",
 "deploy": "wrangler deploy --minify src/index.ts",
 "build": "vite build",
 "lint": "eslint 'src/**/*.{js,jsx,ts,tsx}'",
 "lint:fix": "eslint 'src/**/*.{js,jsx,ts,tsx}' --fix",
 "typecheck": "tsc --noEmit",
 "test": "vitest",
 "test:unit": "vitest run",
 "test:e2e": "playwright test",
 "test:ci": "vitest run && playwright test"
}

このスクリプト群は、開発、デプロイ、静的解析、そして各レベルのテストを網羅しています 47。


6.2 品質ゲートの設定 (tsconfig.json, eslint.config.js)


   * tsconfig.json: compilerOptionsで"strict": trueやVite/esbuildで重要な"isolatedModules": trueなどを設定します。また、クリーンなインポートのためにpathsも設定します 50。
JSON
{
 "compilerOptions": {
   "target": "ESNext",
   "module": "ESNext",
   "moduleResolution": "bundler",
   "lib":,
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

   * eslint.config.js: 推奨ルールを拡張し、typescript-eslintパーサーとプラグイン、そしてPrettierルールを統合した最新のフラット設定の例です 11。
JavaScript
// eslint.config.js
import globals from "globals";
import tseslint from "typescript-eslint";
import pluginReact from "eslint-plugin-react";
import prettierConfig from "eslint-config-prettier";

export default [
 { files: ["**/*.{js,mjs,cjs,ts,jsx,tsx}"] },
 { languageOptions: { globals: globals.browser } },
...tseslint.configs.recommended,
 pluginReact.configs.flat.recommended,
 prettierConfig,
 {
   rules: {
     "react/react-in-jsx-scope": "off",
     //... other custom rules
   }
 }
];



6.3 テストスイートの設定 (vitest.config.ts, playwright.config.ts)


      * vitest.config.ts: テスト環境（jsdomなど）、グローバル設定、tsconfig.jsonと一致させるためのパスエイリアスなどを設定します 52。
TypeScript
// vitest.config.ts
import { defineConfig } from 'vitest/config';
import react from '@vitejs/plugin-react';

export default defineConfig({
 plugins: [react()],
 test: {
   environment: 'jsdom',
   globals: true,
   setupFiles: './src/tests/setup.ts',
 },
});

      * playwright.config.ts: 異なるブラウザ用のprojectsを定義し、baseURLを設定し、デバッグを容易にするためのtraceやscreenshotオプションを設定します 55。
TypeScript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
 testDir: './e2e',
 fullyParallel: true,
 use: {
   baseURL: 'http://localhost:8787',
   trace: 'on-first-retry',
   screenshot: 'only-on-failure',
 },
 projects: } },
   { name: 'firefox', use: {...devices } },
 ],
 webServer: {
   command: 'npm run dev',
   url: 'http://localhost:8787',
   reuseExistingServer:!process.env.CI,
 },
});



6.4 エッジ環境の設定 (wrangler.toml)


このファイルはプロジェクトの心臓部です。Workerのname、エントリポイントmain、compatibility_date、そして最も重要なdurable_objectsのbindingsセクションを定義します。このバインディングが、コード内で使用される名前（例：env.MY_DO）をエクスポートされたクラス名（例：MyDurableObject）に結びつけます 58。


Ini, TOML




name = "my-autonomous-worker"
main = "src/index.ts"
compatibility_date = "2024-05-01"

# Durable Object binding
[[durable_objects.bindings]]
name = "COUNTER_DO"
class_name = "Counter"

# Migration for the Durable Object
[[migrations]]
tag = "v1"
new_classes = ["Counter"]



6.5 自動化フックの設定 (.husky/, lint-staged)


         * .husky/pre-commit: npx lint-stagedを実行するシンプルなシェルスクリプトです 21。
Bash
#!/usr/bin/env sh

. "$(dirname -- "$0")/_/husky.sh"






npx lint-staged
```

            * package.json内のlint-staged: どのファイルがどのコマンドに渡されるかを定義します。例えば、*.{ts,tsx}ファイルはeslint --fixとvitest relatedに渡されます 23。
JSON
"lint-staged": {
 "*.{ts,tsx}": [
   "eslint --fix",
   "vitest related --run"
 ]
}



第4部：指揮者のタクト - AIエージェントへの指示作成


この最終パートでは、これまでに構築したすべてを統合し、AIに対する実践的な指示を作成する方法を解説します。


第7章：自律型エージェントのためのプロンプトエンジニアリングの原則


効果的なプロンプトの基本は、具体性、文脈の提供、例示、そして望ましいフォーマットの定義です 61。AIへの指示は、以下の「ペルソナ-コンテキスト-タスク（PCT）」フレームワークに従うことで、その精度を飛躍的に向上させることができます。
               * ペルソナ (Persona): AIに特定の役割を割り当てます。「あなたはCloudflare上でT3スタックを専門とするエキスパート・フルスタック開発者として振る舞ってください」といった指示は、モデルを適切な知識領域にプライミングします 64。
               * コンテキスト (Context): AIに「世界観」を提供します。第3部で構築した技術スタック、ファイル構造、主要な設定ファイルの詳細を含むテンプレートを提供することが重要です 66。
               * タスク (Task): 「ログイン機能を実装してください」といった、具体的で実行可能な指示を与えます。
また、AIに「ステップバイステップで考えなさい」と指示したり、特定の実行シーケンスに従わせたりすることで、複雑なタスクの出力品質が向上します 64。


第8章：AIインストラクションセット：システムからタスクへ




8.1 「システムプロンプト」 - エージェントの憲法


これは、今後のすべての対話の舞台を設定するマスタープロンプトです。以下に、詳細なシステムプロンプトのテンプレートを示します。
ペルソナ:
あなたは、TypeScript、React、Vite、Cloudflare Workers、Durable Objectsを専門とする、経験豊富なフルスタックソフトウェアエンジニアです。あなたの目標は、高品質で、テストされ、保守可能なコードを記述することです。
コンテキスト:
あなたは以下の技術スタックと構成を持つプロジェクトで作業しています。
               * フロントエンド: React, TypeScript
               * バックエンド: Cloudflare Workers, Durable Objects
               * ビルドツール: Vite
               * テスト: Vitest (単体/コンポーネント), Playwright (E2E)
               * 静的解析: ESLint, Prettier
               * デプロイ: Wrangler CLI
               * 品質ゲート: Husky, lint-stagedによるpre-commitフック
主要なnpmスクリプト:
               * npm run typecheck: TypeScriptの型チェックを実行
               * npm run lint: ESLintでコードを検証
               * npm run test:unit: Vitestで単体テストを実行
               * npm run test:e2e: PlaywrightでE2Eテストを実行
               * git commit: pre-commitフックをトリガーし、すべての品質チェックを実行
コアディレクティブ (最重要指示):
あなたの最優先事項は、品質の高い、テスト済みのコードを記述することです。コードを修正するたびに、必ず以下の検証シーケンスに従ってください：
               1. npm run typecheck を実行します。
               2. npm run lint を実行します。
               3. npm run test:unit を実行します。
               4. npm run test:e2e を実行します。
各ステージでエラーが発生した場合は、次のステージに進む前にそのエラーを分析し、修正しなければなりません。タスクは、git commitがpre-commitフックのエラーなしに成功した場合にのみ完了とみなされます。
このプロンプトは、AIにその役割、作業環境、そして最も重要な「行動規範」を明確に伝えます 68。


8.2 タスク特化プロンプトのギャラリー


上記のシステムプロンプトを基盤として、一般的な開発タスク用のテンプレートを提供します。
               * 機能実装:「確立されたプロジェクト構造を使用して、『Todo作成』機能を実装してください。これには以下が含まれます：1. Cloudflare Workerに新しいAPIエンドポイントを作成する。2. TodoDurableObjectに新しいTodoを保存するメソッドを追加する。3. 新しいTodoを送信するためのフォームを持つReactコンポーネントを作成する。4. Durable ObjectメソッドのVitest単体テストを記述する。5. 完全なユーザーフローのためのPlaywright E2Eテストを記述する。」
               * バグ修正:「E2Eテスト『should delete a todo』が次のエラーで失敗しています： [Playwrightのエラーメッセージ]。テスト出力、提供されたplaywright-trace.zip、およびTodoComponent.tsxとworker/index.tsの関連コードを分析し、バグを特定して修正してください。」 70


8.3 フィードバックループ - 自律性の本質


このセクションでは、我々が構築した「感覚システム」からの出力をエージェントがどのように解釈すべきかを明示的に指示します。
               * 「tsc --noEmitが失敗した場合、エラーメッセージは型の不一致を示しています。指定されたファイルと行番号の型を修正してください。」
               * 「eslintが失敗した場合、エラーメッセージはスタイルまたは品質の問題を示しています。ルールに従ってコードを再フォーマットするか、報告された問題を修正してください。」
               * 「vitestテストが失敗した場合、エラーは期待される出力と実際の出力の『差分』を提供します。この差分を分析して、テスト対象の関数のロジックを修正してください。」
               * 「playwrightテストが失敗した場合、それはユーザーフローが壊れていることを意味します。エラーとトレースファイルが、どのアクションが失敗したかを示します。フロントエンドとバックエンド間の相互作用をデバッグして問題を解決してください。」


第9章：実践的なウォークスルー - AIエージェントと「Todo」機能を構築する


この章では、開発サイクル全体を物語形式で解説します。
               1. 人間のプロンプト: 「AI、Todo項目を完了としてマークする機能を実装してください。」
               2. AIの計画: AIはシステムプロンプトに従い、計画を概説します。「1. TodoDurableObjectにtoggleComplete(id)メソッドを追加。2. WorkerにPATCH /api/todos/:idエンドポイントを追加。3. クリックイベントを処理するReactコンポーネントを更新。4. 単体テストとE2Eテストを記述。」 72
               3. AIの最初の試み: AIがコードを生成します。
               4. AIの自己修正: AIはnpm run test:unitを実行します。テストが失敗。エラーを分析：「Expected isComplete to be true, but received undefined」。DOメソッドから更新された状態を返し忘れたことに気づき、コードを修正します。
               5. さらなる修正: npm run test:e2eを実行。ボタンクリックが登録されず、テストが失敗。Playwrightのトレースを調査し、コンポーネントのonClickハンドラーのタイプミスを発見し、修正します。
               6. 成功: AIはすべてのチェックを再度実行。すべて合格。git commitに進みます。pre-commitフックが実行され、成功。AIは報告します。「タスク完了。Todo項目を完了としてマークする機能が実装され、すべての品質ゲートを通過しました。」


結論：開発の未来は監督にある


開発者の役割は、「機械工」から「建築家兼監督者」へとシフトしています。堅牢で自己修正可能な環境を構築し、効果的にコミュニケーションする方法を学ぶことで、我々はAIを活用して前例のないレベルの生産性を達成し、ソフトウェアエンジニアリングのより創造的な側面に集中できるようになります。このハンドブックが提供するフレームワークは、その未来への第一歩です。
引用文献
               1. en.wikipedia.org, 6月 29, 2025にアクセス、 https://en.wikipedia.org/wiki/TypeScript
               2. 【入門】TypeScriptとは？JavaScriptとの違いとメリット・デメリットから将来性を考察, 6月 29, 2025にアクセス、 https://staff.persol-xtech.co.jp/hatalabo/it_engineer/697.html
               3. TypeScriptとは？特徴やJavaScriptとの違い、将来性まで解説 - エンジニアファクトリー, 6月 29, 2025にアクセス、 https://www.engineer-factory.com/media/skill/1432/
               4. Four Ways to Utilize the TypeScript Compiler for Improved Type-Checking - Medium, 6月 29, 2025にアクセス、 https://medium.com/la-mobilery/four-ways-to-utilize-the-typescript-compiler-for-improved-type-checking-ae9c7c37d846
               5. Getting Started with TypeScript (with Examples) - Treehouse Blog, 6月 29, 2025にアクセス、 https://blog.teamtreehouse.com/getting-started-typescript
               6. Documentation - tsc CLI Options - TypeScript, 6月 29, 2025にアクセス、 https://www.typescriptlang.org/docs/handbook/compiler-options.html
               7. en.wikipedia.org, 6月 29, 2025にアクセス、 https://en.wikipedia.org/wiki/ESLint
               8. eslint について - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/ki0i0ro0/articles/eslint-about
               9. ESLint｜企業のDXを成功へと導くアルサーガパートナーズ, 6月 29, 2025にアクセス、 https://www.arsaga.jp/news/dx-technical-glossary/eslint-stylelint/
               10. ESLintの共通ルール導入とその効果 - Atlas Developers Blog, 6月 29, 2025にアクセス、 https://devlog.atlas.jp/2023/03/13/5044
               11. Vite, React, Eslint, Vitest, TypeScript project setup | by mitrich | Medium, 6月 29, 2025にアクセス、 https://mitrich.medium.com/vite-react-eslint-vitest-typescript-project-setup-95f1923bba36
               12. Configuration Files - ESLint - Pluggable JavaScript Linter, 6月 29, 2025にアクセス、 https://eslint.org/docs/latest/use/configure/configuration-files
               13. 簡単導入！Vitestで始める高速で快適なフロントエンドテスト - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/cloud_ace/articles/a3fdb969e56f39
               14. Vitestとは - Vitestではじめるテスト, 6月 29, 2025にアクセス、 https://kou029w.github.io/vitest-hands-on/about-vitest.html
               15. en.wikipedia.org, 6月 29, 2025にアクセス、 https://en.wikipedia.org/wiki/Playwright_(software)
               16. PlaywrightでE2Eテストを自動化！メリットや使い方を解説 - Qbook, 6月 29, 2025にアクセス、 https://www.qbook.jp/column/1832.html
               17. Playwrightとは何か？概要と基本情報を徹底解説, 6月 29, 2025にアクセス、 https://www.issoh.co.jp/tech/details/3167/
               18. Webテスト自動化ツール：Playwrightの魅力と活用法 - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/muit_techblog/articles/e355268058acb7
               19. git-scm.com, 6月 29, 2025にアクセス、 https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%82%AB%E3%82%B9%E3%82%BF%E3%83%9E%E3%82%A4%E3%82%BA-Git-%E3%83%95%E3%83%83%E3%82%AF#:~:text=pre%2Dcommit%20%E3%83%95%E3%83%83%E3%82%AF%E3%81%AF%E3%80%81%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88,%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88%E3%81%8C%E4%B8%AD%E6%96%AD%E3%81%95%E3%82%8C%E3%81%BE%E3%81%99%E3%80%82
               20. Husky “pre-commit” hooks. We will learn how to integrate a… | by Kaushalkoladiya - Medium, 6月 29, 2025にアクセス、 https://medium.com/@kaushalkoladiya123/configuration-husky-pre-commit-hooks-0995c458c7ab
               21. Get started | Husky, 6月 29, 2025にアクセス、 https://typicode.github.io/husky/get-started.html
               22. Husky, 6月 29, 2025にアクセス、 https://typicode.github.io/husky/
               23. Prettier, lint-staged, husky を使ってgitコミット時に自動整形する, 6月 29, 2025にアクセス、 https://blog.sat.ne.jp/2023/06/23/prettier-lint-staged-husky-%E3%82%92%E4%BD%BF%E3%81%A3%E3%81%A6git%E3%82%B3%E3%83%9F%E3%83%83%E3%83%88%E6%99%82%E3%81%AB%E8%87%AA%E5%8B%95%E6%95%B4%E5%BD%A2%E3%81%99%E3%82%8B/
               24. 【2024/01最新】husky + lint-staged でコミット前にlintを強制する方法 - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/risu729/articles/latest-husky-lint-staged
               25. lint-staged を導入して Lint が通らないコードをコミットできないようにしよう! - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/kira924age/articles/98bc03d898c706
               26. 【Git hooks】pre-commitフック導入 - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/sun_asterisk/articles/97d2b4be675c06
               27. Set up a new React project: Vite, TypeScript, ESLint, Prettier and pre ..., 6月 29, 2025にアクセス、 https://dev.to/denivladislav/set-up-a-new-react-project-vite-typescript-eslint-prettier-and-pre-commit-hooks-3abn
               28. How to set up a pre-commit Git hook with Husky and lint-staged ..., 6月 29, 2025にアクセス、 https://oliviac.dev/blog/set_up_pre_commit_hook_husky_lint_staged/
               29. Pre-commit with husky & lint-staged - DEV Community, 6月 29, 2025にアクセス、 https://dev.to/zhangzewei/pre-commit-with-husky-lint-staged-2kcm
               30. 【Vite入門ガイド】爆速の開発環境で快適フロントエンド開発を実現する方法, 6月 29, 2025にアクセス、 https://www.ryoma.online/vite-introduction/
               31. Viteとは？フロントエンド開発を爆速化するビルドツール - Qiita, 6月 29, 2025にアクセス、 https://qiita.com/tomada/items/91c489e41a20a2fd11ea
               32. Viteとは？ビルドツールとは？Docker上でReact×TypeScript環境を構築する手順, 6月 29, 2025にアクセス、 https://beyondjapan.com/blog/2025/02/viteandbuildtools/
               33. Cloudflare Durable Object 入門 - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/kameoncloud/articles/abffdea40ffa50
               34. [Rust] Miniflareでテストを実行 [Cloudflare Workers] - DevelopersIO - クラスメソッド, 6月 29, 2025にアクセス、 https://dev.classmethod.jp/articles/rust-workers-miniflare/
               35. gihyo.jp, 6月 29, 2025にアクセス、 https://gihyo.jp/article/2024/07/monthly-python-2407#:~:text=Cloudflare%20Workers%E3%81%AF%E3%80%81Cloudflare%E3%81%8C,%E3%82%88%E3%81%86%E3%81%AA%E7%89%B9%E5%BE%B4%E3%81%8C%E3%81%82%E3%82%8A%E3%81%BE%E3%81%99%E3%80%82&text=%E9%A1%9E%E4%BC%BC%E3%81%AE%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E3%81%A8%E3%81%97%E3%81%A6AWS,%E3%81%AF%E7%84%A1%E6%96%99%E6%9E%A0%E3%81%8C%E3%81%82%E3%82%8A%E3%81%BE%E3%81%9B%E3%82%93%E3%80%82
               36. Cloudflare Workers 入門【はじめからそうやって教えてくれればいいのに！】 - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/ak/articles/a2bd28a258b615
               37. Cloudflare Workers | サーバーレスアプリケーションを構築, 6月 29, 2025にアクセス、 https://www.cloudflare.com/ja-jp/developer-platform/products/workers/
               38. Cloudflare WorkersでサーバーレスPythonアプリを構築してみよう | gihyo.jp, 6月 29, 2025にアクセス、 https://gihyo.jp/article/2024/07/monthly-python-2407
               39. 仕事で使うための Cloudflare Workers 入門 Day 2 - Durable Objects - Zenn, 6月 29, 2025にアクセス、 https://zenn.dev/mizchi/articles/cf-worker-for-pro-day2
               40. www.cloudflare.com, 6月 29, 2025にアクセス、 https://www.cloudflare.com/ja-jp/developer-platform/products/durable-objects/#:~:text=Durable%20Objects%E3%81%AF%E3%80%81%E3%82%B3%E3%83%B3%E3%83%94%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0,%E9%81%85%E5%BB%B6%E3%81%AE%E9%80%9A%E4%BF%A1%E3%82%92%E5%AE%9F%E7%8F%BE%E3%80%82
               41. CloudflareのDurable Objects, 6月 29, 2025にアクセス、 https://www.cloudflare.com/ja-jp/developer-platform/products/durable-objects/
               42. Get started - CLI · Cloudflare Workers docs, 6月 29, 2025にアクセス、 https://developers.cloudflare.com/workers/get-started/guide/
               43. Installation via Wrangler (CLI) - Netacea Documentation, 6月 29, 2025にアクセス、 https://docs.netacea.com/netacea-plugin-information/cloudflare/installation-and-configuration/installation-via-wrangler-cli
               44. dev.classmethod.jp, 6月 29, 2025にアクセス、 https://dev.classmethod.jp/articles/rust-workers-miniflare/#:~:text=Miniflare%E3%81%AFCloudflare%20Workers%E3%82%92%E3%83%86%E3%82%B9%E3%83%88%E3%81%99%E3%82%8B%E3%81%9F%E3%82%81%E3%81%AE%E3%82%B7%E3%83%9F%E3%83%A5%E3%83%AC%E3%83%BC%E3%82%BF%E3%81%A7%E3%81%99%E3%80%82&text=Workers%E3%81%AE%E5%8D%98%E4%BD%93%E3%83%86%E3%82%B9%E3%83%88%E3%82%92%E6%9B%B8%E3%81%8F%E3%81%AE%E3%81%AB%E9%87%8D%E5%AE%9D%E3%81%97%E3%81%BE%E3%81%99%E3%80%82
               45. Miniflare - Workers - Cloudflare Docs, 6月 29, 2025にアクセス、 https://developers.cloudflare.com/workers/testing/miniflare/
               46. workers-sdk/packages/miniflare/README.md at main - GitHub, 6月 29, 2025にアクセス、 https://github.com/cloudflare/workers-sdk/blob/main/packages/miniflare/README.md
               47. Package.json Conventions - ESLint - Pluggable JavaScript Linter, 6月 29, 2025にアクセス、 https://eslint.org/docs/latest/contribute/package-json-conventions
               48. How to configure package.json to run eslint script - Stack Overflow, 6月 29, 2025にアクセス、 https://stackoverflow.com/questions/36307581/how-to-configure-package-json-to-run-eslint-script
               49. scripts - npm Docs, 6月 29, 2025にアクセス、 https://docs.npmjs.com/cli/v8/using-npm/scripts/
               50. Features | Vite, 6月 29, 2025にアクセス、 https://vite.dev/guide/features
               51. Vite with TypeScript - Robin Wieruch, 6月 29, 2025にアクセス、 https://www.robinwieruch.de/vite-typescript/
               52. Test Projects | Guide - Vitest, 6月 29, 2025にアクセス、 https://vitest.dev/guide/projects
               53. Vitest.config.ts File Explained. Introduction | by Franklyn Edekobi ..., 6月 29, 2025にアクセス、 https://medium.com/@edekobifrank/vite-config-ts-file-explained-716b7b29f862
               54. Getting Started | Guide - Vitest, 6月 29, 2025にアクセス、 https://vitest.dev/guide/
               55. Test use options | Playwright, 6月 29, 2025にアクセス、 https://playwright.dev/docs/test-use-options
               56. TypeScript - Playwright, 6月 29, 2025にアクセス、 https://playwright.dev/docs/test-typescript
               57. Microsoft Playwright Testing service configuration file options, 6月 29, 2025にアクセス、 https://learn.microsoft.com/en-us/azure/playwright-testing/how-to-use-service-config-file
               58. Environments · Cloudflare Durable Objects docs, 6月 29, 2025にアクセス、 https://developers.cloudflare.com/durable-objects/reference/environments/
               59. Configuring wrangler.toml for your project needs - Edge Computing with Cloudflare Workers: Building Fast, Global Serverless Applications | StudyRaid, 6月 29, 2025にアクセス、 https://app.studyraid.com/en/read/14352/488193/configuring-wranglertoml-for-your-project-needs
               60. Cloudflare Durable Objects - Drizzle ORM, 6月 29, 2025にアクセス、 https://orm.drizzle.team/docs/connect-cloudflare-do
               61. www.prompthub.us, 6月 29, 2025にアクセス、 https://www.prompthub.us/blog/prompt-engineering-for-ai-agents#:~:text=Keep%20it%20simple%3A%20Simplicity%20is,your%20prompts%20based%20on%20performance.
               62. Best practices for prompt engineering with the OpenAI API, 6月 29, 2025にアクセス、 https://help.openai.com/en/articles/6654000-best-practices-for-prompt-engineering-with-the-openai-api
               63. Prompt Engineering for AI Guide | Google Cloud, 6月 29, 2025にアクセス、 https://cloud.google.com/discover/what-is-prompt-engineering
               64. Must Known 4 Essential AI Prompts Strategies for Developers | by Reynald | Medium, 6月 29, 2025にアクセス、 https://reykario.medium.com/4-must-know-ai-prompt-strategies-for-developers-0572e85a0730
               65. Seven Best Practices for AI Prompt Engineering - Campus Rec Magazine, 6月 29, 2025にアクセス、 https://campusrecmag.com/seven-best-practices-for-ai-prompt-engineering/
               66. Structured Workflow for AI-assisted Fullstack App build : r/ChatGPTCoding - Reddit, 6月 29, 2025にアクセス、 https://www.reddit.com/r/ChatGPTCoding/comments/1k7gkyz/structured_workflow_for_aiassisted_fullstack_app/
               67. How to build your Agent: 11 prompting techniques for better AI agents - Augment Code, 6月 29, 2025にアクセス、 https://www.augmentcode.com/blog/how-to-build-your-agent-11-prompting-techniques-for-better-ai-agents
               68. Mastering System Prompts for AI Agents | by Patric - Medium, 6月 29, 2025にアクセス、 https://pguso.medium.com/mastering-system-prompts-for-ai-agents-3492bf4a986b
               69. Best practices for generating AI prompts - Work Life by Atlassian, 6月 29, 2025にアクセス、 https://www.atlassian.com/blog/announcements/best-practices-for-generating-ai-prompts
               70. The Lovable Prompting Bible, 6月 29, 2025にアクセス、 https://lovable.dev/blog/2025-01-16-lovable-prompting-handbook
               71. Writing Effective Prompts for AI Agent Creation - SysAid Documentation, 6月 29, 2025にアクセス、 https://documentation.sysaid.com/docs/writing-effective-prompts-for-ai-agent-creation
               72. AI-Assisted Software Development: A Comprehensive Guide with Practical Prompts (Part 1/3) - Aalap Davjekar, 6月 29, 2025にアクセス、 https://aalapdavjekar.medium.com/ai-assisted-software-development-a-comprehensive-guide-with-practical-prompts-part-1-3-989a529908e0