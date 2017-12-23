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

    operation BellTest (count : Int, initial: Result) : (Int,Int,Int)
    {
        body
        {
          mutable numOnes = 0;              // By default, Q# variables are immutable unless defined specifically as mutable
          mutable agree = 0;
          using (qubits = Qubit[2])         // The 'using' keyword allocates an array of Qubits for this code block
          {
            for (test in 1..count)          // Q# loops always iterate through a range - this is the only 'for' loop type available in Q#
            {
              Set (initial, qubits[0]);     
              Set (Zero, qubits[1]);

              //X(qubits[0]);                 // Flip the qubit before we measure it ... this is a second classical measurement
              H(qubits[0]);                   // The qubit is now in superposition, so half way between 0 and 1 - statistically will measure 
                                              // out in either state roughly half the time (testing shows variable results)
              CNOT(qubits[0],qubits[1]);      // CNOT entangles the two qubits - whatever we measure for the first we will get for the second
                                              // even though we haven't yet measured the first qubit and it could randomly be in either state
                                              // Spooky interaction at a distance indeed...  ;-)
              let res = M(qubits[0]);

              if (M (qubits[1]) == res)
              {
                set agree = agree + 1;
              }
              
              // Count the number of ones we saw
              if (res == One)
              {
                set numOnes = numOnes + 1;    // The 'set' keyword is used to assign mutable variable values 
                                              // (don't cofuse with the 'Set' operation here) 
              }
            }
            Set(Zero, qubits[0]);             // This call to 'Set' is to return the Qubit to a known state when done 
                                              // - as required by the 'using' statement
            Set(Zero, qubits[1]);
          }
          // Return number of times we saw a |0> and number of times we saw a |1>
          return (count - numOnes, numOnes, agree);
        }
    }
}
