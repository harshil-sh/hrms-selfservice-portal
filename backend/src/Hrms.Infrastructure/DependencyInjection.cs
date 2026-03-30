using Hrms.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Hrms.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        var connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? "Server=localhost,1433;Database=HrmsSelfService;User Id=sa;Password=Your_strong_password123;TrustServerCertificate=True;";

        services.AddDbContext<ApplicationDbContext>(options => options.UseSqlServer(connectionString));
        return services;
    }
}
