namespace LibraryChain;

public interface IContract
{
    string Name { get; }
}

public static class Contract : IContract
{
    public static string Name => "contract";
}
