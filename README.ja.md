# delegate-to-grok

Windows 上のローカル Grok Build CLI へ、Codex から安全に調査・リポジトリ確認・明示許可済みの実装を委譲するための防御的なスキルです。

[English](README.md) · [セキュリティ](SECURITY.md) · [安全な委譲ガイド](docs/guides/safe-delegation.md) · [v0.1.0 リリースノート](docs/releases/v0.1.0.md)

## 保護すること

- すべてのヘッドレス実行をラッパー経由に固定し、壊れやすい `grok -p` への直接フォールバックを禁止します。
- プロンプトを一時ファイルで渡すため、引用符・カンマ・複数行・日本語を安全に扱えます。
- 実行前後で認証を検査し、認証状態は隔離された一時領域で扱います。
- 名前付きミューテックスで実行を直列化し、OAuth とセッションの競合を防ぎます。
- 既定は読み取り専用、Grok 内サブエージェント無効、メモリ無効、指定ディレクトリだけを許可する境界です。

## インストール

前提条件は Windows PowerShell 5.1+ または PowerShell 7+、Codex、ローカルに導入済みの `grok` コマンドです。`grok models` が明示的に認証要求を返した場合だけ、別途 `grok login --oauth` を行ってください。

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
Copy-Item -Recurse -Force .\delegate-to-grok-skill\skill "$env:USERPROFILE\.codex\skills\delegate-to-grok"
```

Codex を再起動または更新してスキルを検出させます。

## 使い方

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'このプロジェクトの構成を、ファイルを変更せずにレビューしてください。'
```

既定の許可ルートは `-WorkingDirectory` そのものです。確認済みの親ディレクトリ配下を対象にする場合だけ `-AllowedRoot` を指定してください。`-AllowWrites` はユーザーが変更を明示的に依頼した場合に限ります。

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" -Help
```

## 開発

Windows での検証:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\verify.ps1
```

ラッパー構文、スキルメタデータ、`-Help`、Grok を呼び出す前のディレクトリ境界を検証します。Grok アカウントやネットワークは必要ありません。

## ライセンス

MIT。詳細は [LICENSE](LICENSE) を参照してください。
