# Troubleshooting

## `GROK_CWD_INVALID` or `GROK_CWD_DENIED`

Confirm that `-WorkingDirectory` exists and identifies the intended project. The wrapper permits that exact directory by default. When a child directory must be targeted under a reviewed parent, pass only that confirmed parent through `-AllowedRoot`.

## `GROK_BUSY`

Another wrapper invocation still owns the named lock. Wait for it or inspect its result; do not start a second Grok process or an additional OAuth flow.

## `GROK_AUTH_MISSING`, `GROK_AUTH_NEEDED`, or `GROK_AUTH_UNKNOWN`

Run `grok models` in a fresh process. Only an explicit authentication-required result justifies one `grok login --oauth` flow. If the result is ambiguous, stop and report it rather than guessing the session is valid.

## `GROK_INVOKE_FAILED` or `GROK_AUTH_LOST`

Report the failure and preserve the canonical authentication state. Do not automatically retry, relogin, or manually copy authentication files. Use `-Help` for accepted wrapper parameters and keep prompts in one `-Prompt` string.

## A read-only task changed files

Stop, record the exact changed paths, and report them. Do not revert user data without explicit authorization.
