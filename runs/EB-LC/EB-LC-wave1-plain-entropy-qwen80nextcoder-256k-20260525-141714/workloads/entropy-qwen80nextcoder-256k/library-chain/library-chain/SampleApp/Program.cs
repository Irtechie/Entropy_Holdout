using CoreLib;
using FeatureLib;
using PipelineLib;
using Contracts;

Console.WriteLine($"{Core.Process()}->{Feature.Process()}->{Pipeline.Process()}->{Contract.Process()}");
