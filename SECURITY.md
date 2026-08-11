# Security policy

Do not report vulnerabilities in public issues. Use GitHub's private security advisory for this repository, or contact the maintainers through the organization profile.

Never include Grok OAuth tokens, `%USERPROFILE%\.grok\auth.json`, prompt contents containing credentials, or account diagnostics in a report. A minimal reproduction that uses a dummy prompt and redacted paths is enough.

The wrapper is designed to fail closed. If you find a path that bypasses its filesystem boundary, authentication isolation, or single-flight guard, stop using that path and report it privately.
