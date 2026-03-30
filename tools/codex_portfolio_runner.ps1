param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot/..").Path,
    [string]$TasksFile = "",
    [string]$CodexExecutable = "codex",
    [switch]$Push,
    [switch]$AutoCommit = $true,
    [switch]$NoCodex,
    [switch]$AllowDirtyWorkingTree,
    [string]$BaseBranch = "main",
    [string]$RunnerLogFile = ""
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($TasksFile)) {
    $TasksFile = Join-Path $RepoRoot "tools/tasks.json"
}

$runnerStateDir = Join-Path $RepoRoot ".codex-runner"
if (-not (Test-Path $runnerStateDir)) {
    New-Item -Path $runnerStateDir -ItemType Directory | Out-Null
}

if ([string]::IsNullOrWhiteSpace($RunnerLogFile)) {
    $RunnerLogFile = Join-Path $runnerStateDir "runner.log"
}

function Write-Log {
    param([string]$Message)

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $line = "$timestamp | $Message"
    Write-Host $line
    Add-Content -Path $RunnerLogFile -Value $line
}

function Ensure-FileExists {
    param([string]$PathToCheck)

    if (-not (Test-Path $PathToCheck)) {
        throw "Required file not found: $PathToCheck"
    }
}

function Invoke-RepoCommand {
    param(
        [string]$Command,
        [string]$WorkingDirectory
    )

    Push-Location $WorkingDirectory
    try {
        Write-Log "RUN $Command"

        if ($IsWindows) {
            & powershell.exe -NoProfile -ExecutionPolicy Bypass -Command $Command
        }
        else {
            & pwsh -NoProfile -Command $Command
        }

        if ($LASTEXITCODE -ne 0) {
            throw "Command failed with exit code ${LASTEXITCODE}: $Command"
        }
    }
    finally {
        Pop-Location
    }
}

function Get-TasksData {
    Ensure-FileExists $TasksFile
    return (Get-Content -Path $TasksFile -Raw | ConvertFrom-Json)
}

function Save-TasksData {
    param($TasksData)

    $json = $TasksData | ConvertTo-Json -Depth 100
    Set-Content -Path $TasksFile -Value $json -Encoding UTF8
}

function Get-FirstIncompleteTask {
    param($TasksData)

    foreach ($task in $TasksData.tasks) {
        if ($task.status -ne "completed") {
            return $task
        }
    }

    return $null
}

function Update-Task {
    param(
        $TasksData,
        [string]$TaskId,
        [string]$Status,
        [string]$Notes
    )

    foreach ($task in $TasksData.tasks) {
        if ($task.id -eq $TaskId) {
            $task.status = $Status
            $task.notes = $Notes
            break
        }
    }

    Save-TasksData -TasksData $TasksData
}

function Get-GitPorcelain {
    param([string]$Root)

    Push-Location $Root
    try {
        $output = @(git status --porcelain 2>$null)
        if ($LASTEXITCODE -ne 0) {
            throw "git status failed"
        }

        return @($output)
    }
    finally {
        Pop-Location
    }
}

function Assert-CleanWorkingTree {
    param([string]$Root)

    if ($AllowDirtyWorkingTree) {
        Write-Log "Skipping clean working tree validation because -AllowDirtyWorkingTree was specified."
        return
    }

    $statusLines = @(
        Get-GitPorcelain -Root $Root | Where-Object { $_ -and $_.Trim().Length -gt 0 }
    )

    if ($statusLines.Length -gt 0) {
        throw "Git working tree is not clean. Commit or stash existing changes first, or rerun with -AllowDirtyWorkingTree."
    }
}

function Get-ChangedFiles {
    param([string]$Root)

    $statusLines = @(
        Get-GitPorcelain -Root $Root | Where-Object { $_ -and $_.Trim().Length -gt 0 }
    )

    $files = @()

    foreach ($line in $statusLines) {
        if ($line.Length -ge 4) {
            $trimmed = $line.Substring(3).Trim()
            if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
                $files += $trimmed
            }
        }
    }

    return @($files | Sort-Object -Unique)
}

function Stage-And-Commit {
    param(
        [string]$Root,
        [string[]]$Files,
        [string]$Message,
        [switch]$PushChanges
    )

    Push-Location $Root
    try {
        foreach ($file in $Files) {
            git add -- $file
            if ($LASTEXITCODE -ne 0) {
                throw "git add failed for $file"
            }
        }

        $hasStaged = @(git diff --cached --name-only)
        if ($hasStaged.Length -eq 0) {
            Write-Log "No staged changes found. Skipping commit."
            return
        }

        git commit -m $Message
        if ($LASTEXITCODE -ne 0) {
            throw "git commit failed"
        }

        if ($PushChanges) {
            git push origin $BaseBranch
            if ($LASTEXITCODE -ne 0) {
                throw "git push failed"
            }
        }
    }
    finally {
        Pop-Location
    }
}

function New-CodexPrompt {
    param(
        $TasksData,
        $Task
    )

    $docs = @($TasksData.executionPolicy.readBeforeEachTask) -join ", "
    $criteria = (@($Task.acceptanceCriteria) | ForEach-Object { "- $_" }) -join "`n"
    $tests = (@($Task.testCommands) | ForEach-Object { "- $_" }) -join "`n"

    return @"
Read these files before making changes: $docs.

Execute only task $($Task.id): $($Task.title).
Do not start any later task.
Respect clean architecture boundaries exactly as documented.
Update or add tests required for this task.

Acceptance criteria:
$criteria

Relevant verification commands:
$tests

When done, stop and summarize changed files.
"@
}

function Invoke-Codex {
    param(
        [string]$Executable,
        [string]$Prompt,
        [string]$WorkingDirectory
    )

    Push-Location $WorkingDirectory
    try {
        Write-Log "Invoking Codex CLI for the active task."
        & $Executable $Prompt

        if ($LASTEXITCODE -ne 0) {
            throw "Codex CLI returned exit code ${LASTEXITCODE}"
        }
    }
    finally {
        Pop-Location
    }
}

function Invoke-TestCommands {
    param(
        [string[]]$Commands,
        [string]$WorkingDirectory
    )

    foreach ($command in @($Commands)) {
        if (-not [string]::IsNullOrWhiteSpace($command)) {
            Invoke-RepoCommand -Command $command -WorkingDirectory $WorkingDirectory
        }
    }
}

Ensure-FileExists $TasksFile

Write-Log "Repo root: $RepoRoot"
Write-Log "Tasks file: $TasksFile"
Write-Log "Codex executable: $CodexExecutable"
Write-Log "Auto-commit: $AutoCommit | Push: $Push | NoCodex: $NoCodex"

Assert-CleanWorkingTree -Root $RepoRoot

$tasksData = Get-TasksData
$task = Get-FirstIncompleteTask -TasksData $tasksData

if ($null -eq $task) {
    Write-Log "All tasks are already completed."
    exit 0
}

Write-Log "Active task: $($task.id) - $($task.title)"

$startNote = "Started on $(Get-Date -Format s) by codex_portfolio_runner"
Update-Task -TasksData $tasksData -TaskId $task.id -Status "in_progress" -Notes $startNote
$tasksData = Get-TasksData

try {
    $prompt = New-CodexPrompt -TasksData $tasksData -Task $task
    $promptPath = Join-Path $runnerStateDir "$($task.id)_prompt.txt"
    Set-Content -Path $promptPath -Value $prompt -Encoding UTF8
    Write-Log "Prompt saved to $promptPath"

    if (-not $NoCodex) {
        Invoke-Codex -Executable $CodexExecutable -Prompt $prompt -WorkingDirectory $RepoRoot
    }
    else {
        Write-Log "Skipping Codex execution because -NoCodex was specified."
    }

    Invoke-TestCommands -Commands @($task.testCommands) -WorkingDirectory $RepoRoot

    $tasksData = Get-TasksData
    $completeNote = "Completed on $(Get-Date -Format s) after verification passed"
    Update-Task -TasksData $tasksData -TaskId $task.id -Status "completed" -Notes $completeNote

    if ($AutoCommit) {
        $changedFiles = @(Get-ChangedFiles -Root $RepoRoot)

        if ($changedFiles -notcontains "tools/tasks.json") {
            $changedFiles += "tools/tasks.json"
        }

        if ($changedFiles.Length -gt 0) {
            Stage-And-Commit `
                -Root $RepoRoot `
                -Files $changedFiles `
                -Message "feat($($task.id.ToLower())): complete $($task.title)" `
                -PushChanges:$Push

            Write-Log "Committed verified task changes."
        }
        else {
            Write-Log "No file changes detected after verification."
        }
    }

    Write-Log "Task $($task.id) completed successfully."
}
catch {
    $message = $_.Exception.Message
    Write-Log "Verification failed: $message"

    $tasksData = Get-TasksData
    Update-Task -TasksData $tasksData -TaskId $task.id -Status "blocked" -Notes "Verification failed: $message"

    throw
}