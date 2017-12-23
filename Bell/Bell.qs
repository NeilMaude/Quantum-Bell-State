namespace Quantum.Bell
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Set (desired: Result, q1: Qubit) : ()
    {
        body
        {
            let current = M(q1);            // The 'let' keyword binds mutable variables

            if (desired != current)
            {
              X(q1);
            }
        }
    }

    operation BellTest (count : Int, initial: Result) : (Int,Int)
    {
        body
        {
          mutable numOnes = 0;              // By default, Q# variables are immutable unless defined specifically as mutable
          using (qubits = Qubit[1])         // The 'using' keyword allocates an array of Qubits for this code block
          {
            for (test in 1..count)          // Q# loops always iterate through a range 
            {
              Set (initial, qubits[0]);     

              let res = M(qubits[0]);

              // Count the number of ones we saw
              if (res == One)
              {
                set numOnes = numOnes + 1;    // The 'set' keyword is used to assign mutable variable values 
                                              // (don't cofuse with the 'Set' operation here) 
              }
            }
            Set(Zero, qubits[0]);             // This call to 'Set' is to return the Qubit to a known state when done 
                                              // - as required by the 'using' statement
          }
          // Return number of times we saw a |0> and number of times we saw a |1>
          return (count - numOnes, numOnes);
        }
    }
}
