using FeatureLib;

namespace PipelineLib;

public static class PipelineProvider
{
    public static string Get() => FeatureProvider.Get() + "->pipeline";
}
