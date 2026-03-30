# Development Standards

## General Principles

- Optimize for clarity, maintainability, and testability
- Write code as if another senior engineer will review every change
- Prefer explicitness over cleverness
- Keep abstractions justified by current needs
- Name things in business language where possible

## Clean Architecture Enforcement

### Allowed project references
- Domain -> none
- Application -> Domain
- Infrastructure -> Application, Domain
- API -> Application, Infrastructure at composition root only

### Forbidden patterns
- Controllers calling DbContext directly
- Application handlers referencing EF Core or SQL types directly
- Domain entities inheriting framework base classes
- Frontend components making raw fetch calls inline when a shared client is appropriate
- Shared "Utils" dumping grounds

## C# Conventions

- Enable nullable reference types
- Enable implicit usings only if they do not reduce readability
- Use `record` for immutable request/response contracts where appropriate
- Use `sealed` for classes that are not intended for inheritance
- Use `CancellationToken` in async public methods
- Keep controllers thin
- Prefer one public type per file
- Prefer constructor injection
- Avoid static mutable state

## Domain Modeling Rules

- Entities should protect their own invariants where reasonable
- Prefer intention-revealing methods over raw property mutation
- Use enums for bounded statuses
- Use value objects when they improve correctness and readability
- Keep domain free from persistence and transport concerns

## Application Layer Rules

- Use MediatR request/handler pairs for business use cases
- Use FluentValidation for request validation
- Use interfaces for infrastructure dependencies
- Return explicit result DTOs or typed responses
- Centralize authorization and ownership checks in application workflows for sensitive operations

## Infrastructure Rules

- Keep EF Core configuration in separate configuration classes
- Use repositories only when they add value; avoid meaningless pass-through repositories
- Use transaction boundaries deliberately
- Persist refresh tokens server-side
- Abstract file storage behind interface
- Store only metadata in relational tables for files

## API Rules

- Controllers map HTTP to application requests
- Middleware handles cross-cutting concerns
- Use problem-details style error responses where possible
- Swagger must be enabled in development
- Never put domain/business logic directly in controllers

## Frontend Standards

### Component design
- Keep components focused and composable
- Presentational components should not own server communication
- Route/page components orchestrate feature flows

### State management
- TanStack Query for server state
- Zustand for auth/session and minimal app-global state
- Avoid duplicating server state in Zustand

### TypeScript
- `strict` mode enabled
- Avoid `any`
- Use typed API responses
- Centralize shared DTO types or generate them later if needed

### UX expectations
- Professional internal enterprise UI
- Responsive enough for laptop and desktop
- Clear validation messages
- Loading and error states on all async views

## Testing Standards

- New business behavior should have tests
- Unit tests should be fast and isolated
- Integration tests should validate wiring where valuable
- Frontend tests should focus on behavior, not implementation details
- Do not mark tasks complete without running relevant tests

## Logging and Observability

- Log meaningful application events
- Avoid noisy duplicate logs
- Never log secrets, passwords, or raw refresh tokens
- Include correlation identifiers when practical

## Documentation Standards

- Update docs when a design decision materially changes
- Mermaid diagrams should stay consistent with implementation
- Task notes should be short, factual, and current

## Definition of Ready

A task is ready when:
- scope is clear
- dependencies are satisfied
- acceptance criteria are testable

## Definition of Done

A task is done when:
- implementation is complete
- relevant tests pass
- docs are updated if needed
- `tools/tasks.json` status is updated
