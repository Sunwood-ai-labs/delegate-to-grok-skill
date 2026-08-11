---
lang: ja
---

# はじめに

## 前提条件

- Windows PowerShell 5.1+ または PowerShell 7+
- ローカルスキルを有効にした Codex
- ローカルに導入済みの `grok` コマンド

実行ファイルを確認し、必要な場合だけ認証します。

```powershell
Get-Command grok
grok models
```

`grok models` が明示的に認証要求を返した場合だけ、対話的な `grok login --oauth` を 1 回実行し、続けて `grok models` を再実行してください。`auth.json` を調べたりコピーしたりしないでください。

## スキルをインストール

```powershell
git clone https://github.com/Sunwood-ai-labs/delegate-to-grok-skill.git
& .\delegate-to-grok-skill\scripts\sync-skill.ps1
& .\delegate-to-grok-skill\scripts\sync-skill.ps1 -VerifyOnly
```

Codex を再起動または更新して、新しいローカルスキルを検出させます。

## 読み取り専用で開始

```powershell
& "$env:USERPROFILE\.codex\skills\delegate-to-grok\scripts\invoke-grok.ps1" `
  -WorkingDirectory 'D:\Projects\example' `
  -Prompt 'ファイルを変更せずに構成を確認し、要約してください。'
```

既定の許可ルートは作業ディレクトリそのものです。確認済みの親ディレクトリ配下を対象にする場合だけ `-AllowedRoot` を指定してください。`-AllowWrites` は明示的に変更が許可された実装タスクにだけ使います。
