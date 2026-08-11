---
layout: home
lang: ja

hero:
  name: delegate-to-grok
  text: Codex から Grok Build へ安全に委譲
  tagline: すべてのヘッドレス実行を、安全ガード付き・読み取り専用優先の PowerShell ラッパーに固定する Windows スキルです。
  image:
    src: /icon.svg
    alt: delegate-to-grok のシールドとルートを表すアイコン
  actions:
    - theme: brand
      text: はじめる
      link: /ja/guide/getting-started
    - theme: alt
      text: GitHub で見る
      link: https://github.com/Sunwood-ai-labs/delegate-to-grok-skill

features:
  - title: プロンプトを安全に転送
    details: コマンドライン引数ではなく一時プロンプトファイルを使い、引用符・記号・複数行・日本語を保ちます。
  - title: 既定は読み取り専用
    details: 読み取り専用サンドボックス、既定権限、Grok 内サブエージェント無効、メモリ無効、指定ディレクトリ限定で開始します。
  - title: 認証競合を防止
    details: 実行前後に Grok セッションを検証し、認証状態を隔離してラッパー実行を直列化します。
---

![委譲する二つのエージェントを結ぶ青い保護シールド](/header-v1.png)

## 安全を最優先

スコープ、レビュー、テスト、最終判断は Codex が担います。Grok は相談するエージェントであり、ワークスペースの自律的な所有者ではありません。

インストールは [はじめに](/ja/guide/getting-started) を参照し、書き込みを許可する前に [安全な委譲](/ja/guide/safe-delegation) を確認してください。
