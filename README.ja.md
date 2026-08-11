<p align="center">
  <img src="docs/public/icon.svg" width="112" alt="delegate-to-grok のシールドとルートを表すアイコン">
</p>

<h1 align="center">delegate-to-grok</h1>

<p align="center">Windows 上の Grok Build へ、Codex から安全に調査と明示許可済みの実装を委譲する防御的なスキルです。</p>

<p align="center">
  <img src="docs/public/header-v1.png" alt="委譲する二つのエージェントを結ぶ青い保護シールド" width="100%">
</p>

<p align="center">
  <a href="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/actions/workflows/ci.yml"><img src="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/actions/workflows/ci.yml/badge.svg" alt="Validate workflow"></a>
  <a href="https://github.com/Sunwood-ai-labs/delegate-to-grok-skill/releases/tag/v0.1.0"><img src="https://img.shields.io/github/v/release/Sunwood-ai-labs/delegate-to-grok-skill?display_name=tag" alt="Latest release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/Sunwood-ai-labs/delegate-to-grok-skill" alt="MIT license"></a>
</p>

<p align="center"><a href="README.md">English</a> · <a href="https://sunwood-ai-labs.github.io/delegate-to-grok-skill/ja/">ドキュメント</a> · <a href="SECURITY.md">セキュリティ</a> · <a href="CONTRIBUTING.md">コントリビュート</a></p>

## 🛡️ 保護すること

- すべてのヘッドレス実行をラッパー経由に固定し、壊れやすい `grok -p` への直接フォールバックを禁止します。
- プロンプトを一時ファイルで渡すため、引用符・カンマ・複数行・日本語を安全に扱えます。
- 実行前後で認証を検査し、認証状態は隔離された一時領域で扱います。
- 名前付きミューテックスで実行を直列化し、OAuth とセッションの競合を防ぎます。
- 既定は読み取り専用、Grok 内サブエージェント無効、メモリ無効、指定ディレクトリだけを許可する境界です。

## 🚀 インストール

前提条件は Windows PowerShell 5.1+ または PowerShell 7+、Codex、ローカルに導入済みの `grok` コマンドです。`grok models` が明示的に認証要求を返した場合だけ、別途 `grok login --oauth` を行ってください。

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
Copy-Item -Recurse -Force .\delegate-to-grok-skill\skill "$env:USERPROFILE\.codex\skills\delegate-to-grok"
```

Codex を再起動または更新してスキルを検出させます。

## 🧭 使い方

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'このプロジェクトの構成を、ファイルを変更せずにレビューしてください。'
```

既定の許可ルートは `-WorkingDirectory` そのものです。確認済みの親ディレクトリ配下を対象にする場合だけ `-AllowedRoot` を指定してください。`-AllowWrites` はユーザーが変更を明示的に依頼した場合に限ります。

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" -Help
```

## 📚 ドキュメント

セットアップ、安全な委譲、トラブルシューティング、リリースノートは [英日ドキュメントサイト](https://sunwood-ai-labs.github.io/delegate-to-grok-skill/ja/) を参照してください。

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
