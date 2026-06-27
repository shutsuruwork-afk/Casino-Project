# GameHub 開発環境 (GitHub Codespaces 版)

このプロジェクトは、**GitHub Codespaces** を使用したクラウドネイティブな開発を前提としています。
ローカルのHDDやSSDを一切消費せず、チーム全員が全く同じ環境（Rust, Node.js, Go, PostgreSQL）で即座に開発を開始できます。

---

## 🚀 開発の始め方 (Cursor エディタを使用)

メンバーの方は、以下の手順で自分のCursorエディタとクラウド上の開発環境（Codespace）を接続してください。

### 1. Cursor に拡張機能をインストール
1. Cursorエディタを開き、左の拡張機能（Extensions）アイコンをクリックします。
2. 検索窓で `GitHub Codespaces` を検索し、インストールします。

### 2. GitHub との連携
1. Cursorの左下に表示される「リモートエクスプローラー」のアイコン（または `><` のような緑/青のアイコン）をクリックします。
2. 「Connect to Codespace (Codespace に接続)」を選択し、GitHubアカウントでログイン・認証を済ませます。

### 3. Codespace の起動
1. GitHub上のこのリポジトリのページを開き、緑色の `<> Code` ボタンをクリックします。
2. `Codespaces` タブを選び、`+ Create codespace on main` をクリックします。
3. （※ブラウザ版のVS Codeが立ち上がりますが、そのURLをコピーするか、Cursor側から接続できる状態になります）
4. Cursorに戻り、「Connect to Codespace」から作成した環境を選ぶと、Cursorの画面そのままでクラウド上のコードを編集できるようになります！

---

## 💻 サーバーの起動方法

Cursorのターミナルを開き、以下のコマンドを実行してください。

*   **Lobby UI (Next.js):** `cd lobby-ui` -> `npm run dev` (ポート3000で起動)
*   **Core Server (Rust):** `cd core-server` -> `cargo run` (ポート8080等で起動)
*   **Subsystem (Go):** `cd subsystem` -> `go run main.go`

Codespacesの機能により、起動したポート番号は自動的にローカルPCに転送（ポートフォワード）されるため、お手元のブラウザで `http://localhost:3000` を開くだけで実際の画面を確認できます！
