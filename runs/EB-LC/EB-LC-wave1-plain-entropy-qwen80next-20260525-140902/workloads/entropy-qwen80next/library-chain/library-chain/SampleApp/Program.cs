using Contracts;
using PipelineLib;

namespace SampleApp;

class Program
{
    static void Main()
    {
        Console.WriteLine(Pipeline.Pipeline.Execute() + "->contract");
    }
}
