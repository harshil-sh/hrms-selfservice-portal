# TASKS.md

This document is the human-readable companion to `tools/tasks.json`.

The JSON file is the source of truth for automation.
This file helps developers and interviewers understand the staged execution plan.

## Delivery Stages

### Stage 1 — Repository and Solution Bootstrap
1. Initialize backend solution and core projects
2. Configure project references to enforce Clean Architecture
3. Add shared build settings and code style files
4. Bootstrap frontend with Vite, React, TypeScript, Tailwind
5. Add Docker Compose with SQL Server service

### Stage 2 — Domain and Persistence Foundations
6. Create core domain entities and enums
7. Create EF Core DbContext and entity configurations
8. Add initial migration and database startup instructions
9. Implement seed data for local development
10. Add foundational repository and service abstractions

### Stage 3 — Authentication & Identity
11. Implement password hashing service with BCrypt
12. Implement JWT token generation service
13. Implement refresh token persistence and rotation logic
14. Build login, refresh, logout endpoints
15. Add RBAC policies and auth middleware wiring
16. Add auth unit and integration tests
17. Build frontend auth flow and protected routing
18. Add frontend auth tests

### Stage 4 — Leave Management
19. Model leave balances and leave requests
20. Implement leave submission command with validation
21. Implement overlap validation and balance checks
22. Implement approval/rejection commands
23. Build leave API endpoints
24. Add leave backend tests
25. Build leave frontend pages and forms
26. Add leave frontend tests

### Stage 5 — Payslip Viewer
27. Implement payslip metadata model and storage abstraction
28. Implement HRAdmin upload use case
29. Implement employee download authorization use case
30. Add audit logging for upload/download
31. Build payslip API endpoints
32. Add payslip backend tests
33. Build payslip frontend pages
34. Add payslip frontend tests

### Stage 6 — Cross-Cutting Quality
35. Add global exception handling and problem-details responses
36. Improve Swagger/OpenAPI metadata
37. Add developer onboarding polish and sample env/config docs
38. Final regression run and documentation pass

## Completion Rule

A task is complete only when:
- implementation is done
- relevant tests pass
- `tools/tasks.json` is updated
- changes are committed
