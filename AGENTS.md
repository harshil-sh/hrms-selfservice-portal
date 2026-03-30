# AGENTS.md

This file tells Codex and other AI coding agents exactly how to operate in this repository.

## Mission

Build a production-quality **HRMS Self-Service Portal** using the approved architecture, stack, and task execution workflow defined in this repository.

The output must look like work produced by a senior engineering team, not a demo tutorial.

## Read Order Before Every Task

Always read these files before attempting work:

1. `README.md`
2. `docs/architecture.md`
3. `docs/development-standards.md`
4. `docs/testing-strategy.md`
5. `docs/api-scope.md`
6. `docs/TASKS.md`
7. `tools/tasks.json`

## Primary Objective

Complete the first incomplete task from `tools/tasks.json`, and only that task.

Do not begin any later task.
Do not make speculative improvements outside task scope unless they are strictly required to make the current task pass.

## Mandatory Rules

### Task execution
- Execute only the first task where `status != "completed"`
- Update task progress notes as work proceeds
- Mark a task `completed` only after relevant automated tests pass
- Keep changes tightly scoped to the current task
- If a task is blocked, mark it as `blocked` with a short reason
- Always keep `tools/tasks.json` in sync with actual completion state

### Git discipline
- Commit only files changed for the current task
- Include `tools/tasks.json` in the same commit when the task status changes
- Push after a task is complete if the runner is configured to push
- Never rewrite history
- Never force push

### Architecture discipline
- Respect all Clean Architecture boundaries
- Domain must not depend on Application, Infrastructure, API, or external frameworks
- Application must depend only on Domain
- Infrastructure must implement Application interfaces and persistence concerns
- API must not contain business logic beyond transport concerns and DI composition

### Quality discipline
- Prefer explicit names over clever abstractions
- Add tests with each meaningful behavior change
- Do not leave dead code, commented code, or placeholder TODOs unless the task explicitly asks for them
- Keep methods small and intention-revealing
- Favor deterministic code over hidden magic
- Validate inputs close to the edge
- Fail securely

### Security discipline
- Never store secrets in source control
- Never log plaintext passwords or refresh tokens
- Never bypass authorization checks for convenience
- For payslip files, always verify ownership and role before access
- Audit sensitive actions

## Approved Tech Stack

### Backend
- .NET 8 Web API
- C#
- MediatR
- FluentValidation
- EF Core 8
- SQL Server
- BCrypt
- JWT authentication

### Frontend
- React 18
- TypeScript
- Vite
- Tailwind CSS
- TanStack Query v5
- Zustand
- React Router v6

### Testing
- xUnit + Moq
- Vitest

## Feature Modules

### Authentication & Identity
- Login
- Refresh token rotation
- Logout / token revocation
- RBAC for Employee / Manager / HRAdmin

### Leave Management
- Submit leave request
- Approve/reject leave request
- Leave balance tracking
- Overlap validation

### Payslip Viewer
- HRAdmin uploads payslip PDFs
- Employee downloads only their own payslips
- Full audit log

## Expected Coding Style

### C#
- Use feature-oriented folders within each layer where helpful
- Use records for immutable request/response DTOs when appropriate
- Use async for I/O paths
- Prefer constructor injection
- Keep controllers thin
- Put business rules in Application and Domain
- Keep EF configuration in Infrastructure
- Use `CancellationToken` on async application and API methods

### TypeScript / React
- Use strict typing
- Use route-level organization
- Separate API client code from view components
- Put server state in TanStack Query
- Put short-lived client UI state in component state
- Put app/session state in Zustand only when it genuinely needs to be global
- Avoid over-engineering state management

## Test Expectations

A task is not complete until:
- the relevant unit/integration tests for that task pass
- existing impacted tests still pass
- task status is updated in `tools/tasks.json`

## What Not To Do

- Do not complete multiple tasks in one run
- Do not redesign the architecture without a task asking for it
- Do not replace approved libraries with alternatives
- Do not add unnecessary services, wrappers, or patterns
- Do not edit historical task entries except to update status and notes for the active task
- Do not claim a task is complete when tests were not run

## Completion Checklist For Every Task

Before finalizing a task, verify:
1. Scope matches the active task only
2. Architecture boundaries were respected
3. Tests relevant to the task passed
4. `tools/tasks.json` was updated
5. Task summary is clear and concise
6. Only task-related files are staged for commit

## Suggested Commit Message Format

```text
feat(task-XX): concise description
fix(task-XX): concise description
test(task-XX): concise description
docs(task-XX): concise description
chore(task-XX): concise description
```

## Definition of Done

A task is done only when:
- implementation is complete
- tests pass
- documentation is updated if required
- `tools/tasks.json` is marked `completed`
- task-related changes are committed
