# Codex runner

Use `tools/codex_portfolio_runner.ps1` to:

1. Read `tools/tasks.json`
2. Find the first incomplete task
3. Ask Codex CLI to execute only that task
4. Run verification commands from `tasks.json`
5. Mark the task as completed only if verification passes
6. Commit changed files including `tools/tasks.json`
7. Optionally push to GitHub
