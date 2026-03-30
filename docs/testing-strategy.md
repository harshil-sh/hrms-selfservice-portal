# Testing Strategy

## Objectives

The test strategy should give confidence in:
- business rules
- authentication and authorization flows
- module boundaries
- regression safety
- key user journeys

## Testing Pyramid

### Backend
- Unit tests for domain logic and application handlers
- Integration tests for API endpoints, auth flows, persistence wiring, and file access rules

### Frontend
- Component and feature tests with Vitest
- Route/interaction tests for critical workflows
- Mocked API tests for predictable UI behavior

## Backend Test Projects

```text
backend/tests/
├─ Hrms.Domain.Tests/
├─ Hrms.Application.Tests/
├─ Hrms.Infrastructure.Tests/
└─ Hrms.API.Tests/
```

## What To Unit Test

### Domain
- leave overlap logic
- leave status transitions where modeled in entity methods
- aggregate invariants
- role or policy helper logic if domain-owned

### Application
- login command handler behavior
- refresh token rotation behavior
- leave submission validation
- leave approval/rejection orchestration
- payslip authorization checks
- audit logging triggers through service abstractions

## What To Integration Test

- authentication endpoints
- refresh token endpoint behavior
- authorized access by role
- leave submission end-to-end path
- leave approval/rejection end-to-end path
- payslip upload/download authorization
- audit records written for sensitive actions

## Frontend Test Areas

### Auth
- login form submission
- token/session store updates
- protected route redirects
- role-based menu rendering

### Leave
- submit leave form validation
- leave list and status rendering
- approval action handling
- error and loading states

### Payslips
- payslip list rendering
- download interaction
- upload form for HRAdmin
- role-based access to upload UI

## Recommended Tooling

### Backend
- xUnit
- Moq
- FluentAssertions optional
- Testcontainers optional later, but not required for first slice
- SQLite in-memory may be acceptable for selected integration tests where SQL Server-specific behavior is not relevant

### Frontend
- Vitest
- React Testing Library
- MSW for API mocking

## Test Naming

### Backend
Use descriptive names:
- `SubmitLeaveRequest_ShouldReject_WhenDatesOverlap`
- `RefreshToken_ShouldRotateAndRevokePreviousToken`

### Frontend
Use behavior-first names:
- `shows validation message when end date is before start date`
- `redirects unauthenticated user to login page`

## Task Completion Policy

A task is marked complete only when:
- all tests relevant to the task pass
- changed tests pass locally
- `tools/tasks.json` is updated accordingly

## Minimum Required Coverage By Module

### Authentication & Identity
Must include:
- login success/failure
- refresh token rotation
- unauthorized access rejection
- role-protected endpoint coverage

### Leave Management
Must include:
- valid request submission
- overlap rejection
- manager approval/rejection
- balance updates where implemented

### Payslip Viewer
Must include:
- HRAdmin upload allowed
- non-HR upload denied
- employee can access own file only
- employee cannot access another employee file
- audit log recorded

## Test Data Strategy

- Use deterministic seed data
- Avoid brittle date assumptions where possible
- Use builders/factories for readability in tests
- Keep test fixtures close to the module they support

## CI-Ready Command Targets

### Backend
```bash
dotnet restore
dotnet build
dotnet test
```

### Frontend
```bash
npm install
npm run test
```

## Anti-Patterns To Avoid

- brittle snapshot-heavy tests without good reason
- asserting implementation details instead of outcomes
- over-mocking simple logic
- database-dependent unit tests
- marking tasks complete based only on manual verification
