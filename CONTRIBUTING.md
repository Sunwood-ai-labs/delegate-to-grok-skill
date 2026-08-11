# Contributing

Keep changes focused on safe delegation behavior. Do not add a direct `grok -p` path, automatic login, credential logging, or a bypass-permissions default.

Before opening a pull request, run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tests\verify.ps1
```

For wrapper changes, add a deterministic regression check whenever practical. The test suite must not require a live Grok account.
