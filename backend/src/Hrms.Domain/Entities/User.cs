using Hrms.Domain.Common;
using Hrms.Domain.Enums;

namespace Hrms.Domain.Entities;

public sealed class User : BaseEntity
{
    public string EmployeeCode { get; private set; } = string.Empty;
    public string FullName { get; private set; } = string.Empty;
    public string Email { get; private set; } = string.Empty;
    public string PasswordHash { get; private set; } = string.Empty;
    public UserRole Role { get; private set; }
    public bool IsActive { get; private set; } = true;

    private User() { }

    public User(string employeeCode, string fullName, string email, string passwordHash, UserRole role)
    {
        EmployeeCode = employeeCode;
        FullName = fullName;
        Email = email;
        PasswordHash = passwordHash;
        Role = role;
    }
}
