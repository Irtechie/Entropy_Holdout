using CoreLib;

namespace FeatureLib;

public static class FeatureProvider
{
    public static string Get() => CoreProvider.Get() + "->feature";
}
