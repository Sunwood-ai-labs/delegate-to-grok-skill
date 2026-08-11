---
layout: home
lang: ja

hero:
  name: delegate-to-grok
  text: Codex から Grok Build へ仕事を委譲
  tagline: 調査・レビュー・比較・実装補助を Grok Build へ渡し、スコープ・検証・最終判断は Codex が担う Windows スキルです。
  image:
    src: /icon.svg
    alt: delegate-to-grok の委譲レーンを表すアイコン
  actions:
    - theme: brand
      text: はじめる
      link: /ja/guide/getting-started
    - theme: alt
      text: GitHub で見る
      link: https://github.com/Sunwood-ai-labs/delegate-to-grok-skill

features:
  - title: タスクを絞って委譲
    details: 指定ワークスペースから、調査・レビュー・比較・公開X調査・実装補助を Grok へ委譲します。
  - title: 結果を Codex に戻す
    details: Grok は証拠と実装補助を返し、スコープ・検証・最終判断は Codex が担います。
  - title: 実行契約を明示
    details: 権限、ワークスペース境界、認証確認、単一実行モデルを暗黙の CLI 挙動に任せず明示します。
---

![Codexの中央制御から委譲タスクを分配し、Grokの結果を集約するワークフロー図](/header-v2.png)

## 委譲モデル

Grok は専用の委譲レーンとして使います。よく絞ったタスクを渡し、証拠または変更案を受け取り、Codex がレビューして統合します。このラッパーは単一実行モデルです。複数トラックを協調させる場合は、Grok 内部の並列実行と誤認させず、Codex 側のワークフローとして設計してください。

インストールは [はじめに](/ja/guide/getting-started) を参照し、書き込みを許可する前に [実行契約](/ja/guide/safe-delegation) を確認してください。
