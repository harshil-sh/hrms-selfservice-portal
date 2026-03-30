# HRMS Self-Service Portal

Production-quality reference implementation of an enterprise HRMS self-service platform, built as a portfolio project to demonstrate senior-level architecture, delivery discipline, and domain depth.

## Background

This project is inspired by a real HRMS Self-Service platform led at **MobiTrail** for **Axis Bank**, one of India's largest financial institutions. That platform won the **Asian Banker Award for Best Retail Banking Software** and improved operational efficiency by **40%** across HR operations.

This repository is not a copy of the original system. It is a modernized reference implementation that demonstrates the same business domain understanding using current engineering practices.

## Project Goals

- Showcase a production-grade full-stack architecture
- Demonstrate Clean Architecture in a realistic business domain
- Implement secure identity flows with JWT and refresh token rotation
- Model HR workflows with clear module boundaries
- Provide a strong codebase for interviews, code reviews, and technical discussions
- Support AI-assisted delivery through task-driven Codex execution

## Tech Stack

### Backend
- .NET 8 Web API
- C#
- Clean Architecture
- Entity Framework Core 8
- SQL Server (Docker)
- MediatR
- FluentValidation
- BCrypt password hashing
- JWT authentication with refresh token rotation

### Frontend
- React 18
- TypeScript
- Vite
- Tailwind CSS
- TanStack Query v5
- Zustand
- React Router v6

### Testing
- xUnit
- Moq
- Vitest

### Local Infrastructure
- Docker Compose
- SQL Server container

### Documentation
- Swagger / OpenAPI
- Mermaid diagrams
- Markdown-driven engineering docs

## Core Feature Modules

### 1. Authentication & Identity
- User registration and provisioning by HRAdmin
- JWT access tokens
- Refresh token rotation
- Role-based access control
- Roles: `Employee`, `Manager`, `HRAdmin`

### 2. Leave Management
- Leave request submission
- Manager approval and rejection
- Leave balance tracking
- Overlap validation
- Audit-ready decision history

### 3. Payslip Viewer
- HRAdmin uploads employee payslip PDFs
- Employees securely download only their own payslips
- Full audit logging for upload and download events

## Clean Architecture Rules

These rules are mandatory and must be enforced in code review and during Codex task execution.

- **Domain**
  - Contains entities, enums, value objects, and base abstractions only
  - Must not depend on any other project
- **Application**
  - Contains CQRS handlers, interfaces, DTOs, validators, authorization policies
  - Depends on `Domain` only
- **Infrastructure**
  - Contains EF Core, repositories, persistence, auth services, file storage, migrations
  - Depends on `Application` and `Domain`
- **API**
  - Contains controllers, middleware, filters, DI composition, Swagger config
  - Depends on `Application`
  - Must not directly reference Infrastructure types except at startup/DI registration boundary

## Proposed Repository Structure

```text
hrms-selfservice-portal/
├─ backend/
│  ├─ src/
│  │  ├─ Hrms.Domain/
│  │  ├─ Hrms.Application/
│  │  ├─ Hrms.Infrastructure/
│  │  └─ Hrms.API/
│  ├─ tests/
│  │  ├─ Hrms.Domain.Tests/
│  │  ├─ Hrms.Application.Tests/
│  │  ├─ Hrms.Infrastructure.Tests/
│  │  └─ Hrms.API.Tests/
│  ├─ Hrms.sln
│  └─ Directory.Build.props
├─ frontend/
│  ├─ src/
│  ├─ public/
│  ├─ tests/
│  ├─ package.json
│  └─ vite.config.ts
├─ docs/
├─ tools/
├─ docker-compose.yml
├─ .editorconfig
└─ .gitignore
```

## Expected Delivery Style

This project is designed to be built incrementally by an AI coding agent and reviewed by a human developer.

### Delivery rules
- One task at a time
- Do not start a later task before the current task is complete
- Mark a task complete only after the relevant tests pass
- Commit only task-related changes
- Push `tools/tasks.json` after each completed task so GitHub reflects progress

## Local Setup Targets

- Run SQL Server via Docker Compose
- Run backend locally with Swagger enabled
- Run frontend locally with Vite
- Keep local developer onboarding under 10 minutes once prerequisites are installed

## Security Principles

- Passwords must never be stored in plain text
- BCrypt password hashing is required
- Refresh token rotation is required
- Role checks must be enforced server-side
- File download authorization must be validated at API layer and application layer
- Audit events must be written for sensitive actions

## Non-Goals for MVP

- SSO / Azure AD integration
- Multi-tenant architecture
- Payroll calculations
- Biometric attendance
- Advanced notification engine
- Mobile app

## Documents to Read First

1. `AGENTS.md`
2. `docs/architecture.md`
3. `docs/development-standards.md`
4. `docs/testing-strategy.md`
5. `docs/api-scope.md`
6. `docs/TASKS.md`
7. `tools/tasks.json`

## Interview Talking Points

- Clean Architecture boundaries were enforced from day one
- JWT + refresh token rotation was implemented with audit-aware security design
- HR workflows were modelled with realistic business constraints
- AI task automation was controlled through deterministic task metadata and pass/fail completion rules
- The project was intentionally designed like a real enterprise modernization effort rather than a toy CRUD demo
