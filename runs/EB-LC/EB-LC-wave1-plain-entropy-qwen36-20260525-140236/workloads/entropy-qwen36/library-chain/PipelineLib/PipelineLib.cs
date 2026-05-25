using FeatureLib;

namespace PipelineLib
{
    public static class PipelineLib
    {
        public static string GetPipeline() => $"{FeatureLib.GetFeature()}->pipeline";
    }
}
