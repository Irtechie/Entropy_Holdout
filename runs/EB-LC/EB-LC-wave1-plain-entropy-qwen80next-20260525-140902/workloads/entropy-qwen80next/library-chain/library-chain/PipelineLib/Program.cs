namespace PipelineLib;

public static class Pipeline
{
    public static string Execute() => Feature.Feature.Execute() + "->pipeline";
}
