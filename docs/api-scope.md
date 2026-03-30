# API Scope

This document defines the intended initial API surface for the MVP.

## Base Principles

- JSON REST API
- JWT bearer authentication
- Role-based authorization
- Consistent error responses
- Versioned under `/api/v1`

## Authentication & Identity

### POST `/api/v1/auth/login`
Authenticate a user and return:
- access token
- refresh token
- user profile summary

### POST `/api/v1/auth/refresh`
Rotate refresh token and return:
- new access token
- new refresh token

### POST `/api/v1/auth/logout`
Revoke active refresh token/session.

### GET `/api/v1/auth/me`
Return current user identity and role claims.

## Leave Management

### POST `/api/v1/leaves`
Employee submits a leave request.

### GET `/api/v1/leaves/me`
Employee views own leave requests.

### GET `/api/v1/leaves/pending-approvals`
Manager or HRAdmin views pending requests requiring action.

### POST `/api/v1/leaves/{leaveRequestId}/approve`
Manager or HRAdmin approves a request.

### POST `/api/v1/leaves/{leaveRequestId}/reject`
Manager or HRAdmin rejects a request.

### GET `/api/v1/leave-balances/me`
Employee views current leave balance.

## Payslip Viewer

### POST `/api/v1/payslips`
HRAdmin uploads a payslip PDF for an employee.

Suggested request:
- multipart form-data
- employee id
- year
- month
- file

### GET `/api/v1/payslips/me`
Employee lists own payslips.

### GET `/api/v1/payslips/{payslipId}/download`
Authorized user downloads payslip file.

## Audit

Audit is typically internal, but for development or HRAdmin visibility a scoped endpoint may later exist.

Potential future endpoint:
- `GET /api/v1/audit?entityType=Payslip&entityId=...`

Not required for MVP unless added by task.

## Response Conventions

### Success
- use standard HTTP status codes
- return typed JSON objects
- avoid overly generic wrappers unless consistently applied

### Validation errors
- `400 Bad Request`
- include field-level validation details

### Unauthorized
- `401 Unauthorized`

### Forbidden
- `403 Forbidden`

### Not found
- `404 Not Found`

## Example Auth Response

```json
{
  "accessToken": "jwt-token",
  "refreshToken": "refresh-token",
  "expiresIn": 900,
  "user": {
    "id": "7c8f0b4d-4f76-4b1f-8d45-c86c52bf5f76",
    "employeeCode": "EMP1001",
    "email": "employee@hrms.local",
    "role": "Employee",
    "displayName": "Alex Employee"
  }
}
```

## Example Leave Submission Request

```json
{
  "startDate": "2026-04-06",
  "endDate": "2026-04-08",
  "reason": "Family commitment"
}
```

## Example Leave Request Response

```json
{
  "id": "cbf9d99b-b73c-4fdd-89c8-cf5fbb82c30e",
  "status": "Pending",
  "startDate": "2026-04-06",
  "endDate": "2026-04-08",
  "reason": "Family commitment",
  "submittedAtUtc": "2026-03-30T09:00:00Z"
}
```

## Example Payslip Metadata Response

```json
{
  "id": "f8cb57e2-5a2a-45af-9eb4-93dc25f4875c",
  "year": 2026,
  "month": 3,
  "fileName": "Payslip_March_2026.pdf",
  "uploadedAtUtc": "2026-03-30T09:10:00Z"
}
```

## Swagger Requirements

- Swagger enabled in development
- JWT bearer scheme documented
- Endpoint summaries present
- Request/response examples added for high-value endpoints when practical
