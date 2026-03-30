using Microsoft.EntityFrameworkCore;

namespace Hrms.Application.Common.Abstractions;

public interface IApplicationDbContext
{
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}
