using PipelineLib;
using Contracts;

namespace SampleApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var pipeline = new PipelineService();
            var contract = new ContractService(); // Assuming a simple implementation for demonstration

            string core = new CoreService().GetCoreIdentifier();
            string feature = new FeatureService().GetFeatureIdentifier();
            string pipelineId = pipeline.GetPipelineIdentifier();
            string contractId = contract.GetContractIdentifier();

            Console.WriteLine($"{core}->{feature}->{pipelineId}->{contractId}");
        }
    }
}
