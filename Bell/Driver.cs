using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace Quantum.Bell
{
  class Driver
  {
    static void Main(string[] args)
    {
      using (var sim = new QuantumSimulator())                            // 'sim' is the Q# quantum simulator
      {
        // Try initial values
        Result[] initials = new Result[] { Result.Zero, Result.One };
        foreach (Result initial in initials)
        {
          var res = BellTest.Run(sim, 1000, initial).Result;              // 'Run' is the method to run the quantum simulation
                                                                          // 'Run' is asynchronous, but fetching the 'Result' property blocks
                                                                          // execution until the task completes and makes this synchronous.
          var (numZeros, numOnes, agree) = res;
          System.Console.WriteLine(
            $"Init:{initial,-4} 0s={numZeros,-4} 1s={numOnes,-4} agree={agree,-4}");
        }
      }
      System.Console.WriteLine("Press any key to continue...");
      System.Console.ReadKey();
    }
  }
}