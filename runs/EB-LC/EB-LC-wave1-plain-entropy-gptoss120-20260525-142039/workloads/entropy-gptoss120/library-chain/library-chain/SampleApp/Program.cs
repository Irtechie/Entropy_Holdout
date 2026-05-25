using System;
using CoreLib;
using FeatureLib;
using PipelineLib;
using Contracts;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var result = $"{Core.GetMessage()}->{Feature.GetMessage()}->{Pipeline.GetMessage()}->{Contract.GetMessage()}";
            Console.WriteLine(result);
        }
    }
}
