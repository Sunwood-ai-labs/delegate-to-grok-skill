# Safe delegation guide

`delegate-to-grok` treats Grok as a consulted agent, not an autonomous owner of the workspace. The wrapper addresses four observed failure classes: PowerShell prompt argument splitting, stale or missing authentication, ambiguous command parameters, and concurrent session/OAuth use.

## Start read-only

Pass the exact project directory to `-WorkingDirectory` and one complete task string to `-Prompt`. The wrapper writes that prompt to a temporary UTF-8 file and invokes Grok with a read-only sandbox, default permission mode, no subagents, and no memory.

The default approved root is the same exact working directory. When the target must be a subdirectory of a reviewed parent, supply that parent as `-AllowedRoot`; do not use a broad drive or user-profile root.

## Treat authentication as a single-flight resource

The wrapper checks `grok models` before and after a task. It only accepts an explicit logged-in confirmation plus a model list. It also uses a named mutex, so a second invocation reports `GROK_BUSY` rather than racing the first process's authentication state.

If authentication is explicitly absent, launch one interactive `grok login --oauth` flow and verify it with `grok models` before retrying. Do not inspect or copy the canonical authentication file yourself.

## Escalate deliberately

`-AllowWrites` is only for a user-authorized implementation request. Before invoking it, record repository guidance and the pre-run git state. Afterward, inspect every changed file and run proportionate checks independently. The wrapper never commits, pushes, logs in, logs out, or bypasses permission prompts.

## Interpret output

Grok output is evidence, not a final conclusion. Independently check technical, time-sensitive, high-stakes, and public-X claims against primary sources. For public X research, do not post or interact; collect direct URLs and distinguish verified facts from reported claims.
