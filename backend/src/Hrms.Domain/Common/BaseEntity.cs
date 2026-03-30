namespace Hrms.Domain.Common;

public abstract class BaseEntity
{
    public Guid Id { get; protected set; } = Guid.NewGuid();
    public DateTime CreatedUtc { get; protected set; } = DateTime.UtcNow;
    public DateTime? ModifiedUtc { get; protected set; }

    public void MarkModified() => ModifiedUtc = DateTime.UtcNow;
}
