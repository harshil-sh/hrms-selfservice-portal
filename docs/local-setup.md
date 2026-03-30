# Local Setup

## Prerequisites

- .NET 8 SDK
- Node.js 20+
- Docker Desktop
- Git
- PowerShell 7 recommended

## Start SQL Server

```bash
docker compose up -d
```

## Backend expected commands

```bash
cd backend
dotnet restore
dotnet build
dotnet test
```

## Frontend expected commands

```bash
cd frontend
npm install
npm run build
npm run test
```

## Runner

The PowerShell runner is located at:

```text
tools/codex_portfolio_runner.ps1
```

Example usage:

```powershell
pwsh ./tools/codex_portfolio_runner.ps1
pwsh ./tools/codex_portfolio_runner.ps1 -Push
```

## Important Note

The runner verifies and finalizes the current task.
Codex still needs to implement the code changes before the runner is executed.
