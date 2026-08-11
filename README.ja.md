<p align="center">
  <img src="docs/public/icon.svg" width="112" alt="delegate-to-grok の委譲レーンを表すアイコン">
</p>

<h1 align="center">delegate-to-grok</h1>

<p align="center">Windows 上で、Codex から Grok Build へ調査・レビュー・比較・実装補助を委譲するスキルです。</p>

<p align="center">
  <img src="docs/public/header-v2.png" alt="Codexの中央制御から委譲タスクを分配し、Grokの結果を集約するワークフロー図" width="100%">
</p>

<p align="center">
  <a href="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/actions/workflows/ci.yml"><img src="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/actions/workflows/ci.yml/badge.svg" alt="Validate workflow"></a>
  <a href="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/releases/tag/v0.1.0"><img src="https://img.shields.io/github/v/release/Sunwood-ai-labs/delegate-to-grok-skill?display_name=tag" alt="Latest release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Sunwood-ai-labs/delegate-to-grok-skill" alt="MIT license"></a>
</p>

<p align="center"><a href="README.md">English</a> · <a href="https://sunwood-ai-labs.github.io/delegate-to-grok-skill/ja/">ドキュメント</a> · <a href="SECURITY.md">セキュリティ</a> · <a href="CONTRIBUTING.md">コントリビュート</a></p>

## 🧩 できること

- リポジトリ調査、コードレビュー、比較、公開 X 調査、実装補助を Grok Build へ委譲します。
- タスクのスコープ、証拠確認、テスト方針、最終判断は Codex が担います。
- 変更や結論を統合する前に、Grok の所見を第二の視点として持ち帰れます。
- Codex 側で独立した複数トラックを協調できます。このラッパー自体は Grok CLI 呼び出しを意図的に単一実行に保ちます。

## ⚙️ 実行契約

ラッパーは予測可能な実行契約を提供します。プロンプトは一時ファイルで渡し、権限とワークスペース境界を明示し、タスク前後で認証とセッションを確認します。既定は読み取り専用で、`-AllowWrites` はユーザーが明示的に許可した場合だけの昇格です。

## 🚀 インストール

前提条件は Windows PowerShell 5.1+ または PowerShell 7+、Codex、ローカルに導入済みの `grok` コマンドです。`grok models` が明示的に認証要求を返した場合だけ、別途 `grok login --oauth` を行ってください。

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
Copy-Item -Recurse -Force .\delegate-to-grok-skill\skill "$env:USERPROFILE\.codex\skills\delegate-to-grok"
```

Codex を再起動または更新してスキルを検出させます。

## 🧭 タスクを委譲する

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'このプロジェクトの構成を、ファイルを変更せずにレビューしてください。'
```

既定の許可ルートは `-WorkingDirectory` そのものです。確認済みの親ディレクトリ配下を対象にする場合だけ `-AllowedRoot` を指定してください。`-AllowWrites` はユーザーが変更を明示的に依頼した場合に限ります。

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" -Help
```

## 🧭 複数トラックを協調する

Grok は Codex が管理する作業トラックの一つとして使います。レビューや比較を委譲し、証拠を持ち帰り、Codex が他のエージェントや一次情報と照合して統合します。ラッパーは Grok 内部の並列実行を提供するものではなく、Grok CLI 呼び出しを意図的に直列化します。

## 📚 ドキュメント

セットアップ、実行契約、トラブルシューティング、リリースノートは [英日ドキュメントサイト](https://sunwood-ai-labs.github.io/delegate-to-grok-skill/ja/) を参照してください。

## 🧪 開発

Windows での検証:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\verify.ps1
npm --prefix .\docs run docs:build
```

ラッパー構文、スキルメタデータ、`-Help`、Grok を呼び出す前のディレクトリ境界を検証します。Grok アカウントやネットワークは必要ありません。

## 🔐 セキュリティ

脆弱性は非公開で報告し、OAuth 状態・認証情報を含むプロンプト・アカウント診断を Issue に含めないでください。詳細は [SECURITY.md](SECURITY.md) を参照してください。

## 🤝 コントリビュート

変更を提案する前に [CONTRIBUTING.md](CONTRIBUTING.md) を読んでください。ヘッドレス実行は必ずラッパーを経由させます。

## 📄 ライセンス

MIT。詳細は [LICENSE](LICENSE) を参照してください。
