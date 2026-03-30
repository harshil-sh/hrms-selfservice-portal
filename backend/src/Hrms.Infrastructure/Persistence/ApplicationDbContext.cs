using Hrms.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace Hrms.Infrastructure.Persistence;

public sealed class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
    {
    }

    public DbSet<User> Users => Set<User>();
}
