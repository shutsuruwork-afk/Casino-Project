# 📡 GameHub 初期 API 仕様書 (Hello World 連携版)

本プロジェクト（Casino-Project）は、複数の言語（Rust, Go, Next.js, Godot）が協調して動作するマイクロサービス的な構成を取ります。
このドキュメントは、各システム間が通信するための最初の「連携の土台」となるAPIエンドポイントの仕様を定義したものです。

---

## 1. 🐹 サブシステム (Go)
**役割**: 認証、ユーザー管理、軽量なデータ処理などを行うAPIサーバー
**ポート**: `8081`
**ベースURL**: `http://localhost:8081`

### 1.1. ステータス確認 API
フロントエンドからバックエンドの死活監視・通信テストを行うためのエンドポイントです。

*   **Endpoint**: `/api/status`
*   **Method**: `GET`
*   **CORS**: 許可（Next.jsの `localhost:3000` からのアクセスを許可）
*   **Response (200 OK)**:
    ```json
    {
      "service": "subsystem (Go)",
      "status": "ok",
      "timestamp": "2026-06-27T12:00:00Z"
    }
    ```

---

## 2. 🦀 コアゲームサーバー (Rust)
**役割**: カジノゲームの進行、リアルタイムな状態同期、WebSocket接続の管理
**ポート**: `8080`
**ベースURL**: `http://localhost:8080` (WS: `ws://localhost:8080`)

### 2.1. ヘルスチェック API
インフラ側（Docker/Codespace）や別サービスから、Rustサーバーが生きているかを確認します。

*   **Endpoint**: `/api/health`
*   **Method**: `GET`
*   **Response (200 OK)**:
    ```text
    OK
    ```

### 2.2. リアルタイム通信 (WebSocket) エコーテスト
Godot（ゲームクライアント）やNext.js（UI）が、WebSocketで接続できるかを確認するための最初のテストエンドポイントです。
送信したテキストがそのまま返ってくる（エコーされる）仕様です。

*   **Endpoint**: `/ws`
*   **Protocol**: `ws://` (WebSocket)
*   **接続テスト**:
    *   **Client Send**: `"Hello Server!"`
    *   **Server Reply**: `"Hello Server!"` (そのまま返送)

---

## 3. ⚛️ フロントエンド (Next.js)
**役割**: ロビー画面、ログイン、ゲーム選択UI
**ポート**: `3000`
**ベースURL**: `http://localhost:3000`

### 3.1. 連携テストパネル (`/`)
起動直後のトップページ (`/`) には、上記の2つのバックエンド（Go, Rust）と正常に通信できるかを確認するためのテストボタンを配置します。

*   **機能1**: 「Go APIをテスト」ボタンを押すと、`GET http://localhost:8081/api/status` を叩き、結果を画面に表示する。
*   **機能2**: 「Rust WebSocketをテスト」ボタンを押すと、`ws://localhost:8080/ws` に接続し、メッセージの送受信結果を画面に表示する。
