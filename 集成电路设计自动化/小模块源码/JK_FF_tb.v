`timescale 1ns / 1ns
`include "JK_FF.v"

module JK_FF_tb;
    // Declare inputs as registers and outputs as wires
    reg CLK;
    reg J;
    reg K;
    reg SET;
    reg RS;
    wire Q;

    // Instantiate the JK_FF module
    JK_FF uut (
        .CLK(CLK),
        .J(J),
        .K(K),
        .SET(SET),
        .RS(RS),
        .Q(Q)
    );

    // Declare expected output for comparison (optional, but useful for debugging)
    reg expected_Q;

    initial begin
        // Monitor the inputs and output
        $monitor("Time = %0d, CLK = %b, J = %b, K = %b, SET = %b, RS = %b, Q = %b, Expected Q = %b", $time, CLK, J, K, SET, RS, Q, expected_Q);

        // Initialize inputs and expected output
        CLK = 0;
        SET = 1;
        RS = 1;
        expected_Q = 0; // Initial state is reset

        // Wait for 20ns before starting the test cases
        #20;

        // Test Case 1: J=0, K=0 (No change)
        J = 0; K = 0; expected_Q = 0; // Q should remain 0
        #20; CLK = 1; #20; CLK = 0; #20;

        // Test Case 2: J=0, K=1 (Reset)
        J = 0; K = 1; expected_Q = 0; // Q should be reset to 0
        #20; CLK = 1; #20; CLK = 0; #20;

        // Test Case 3: J=1, K=0 (Set)
        J = 1; K = 0; expected_Q = 1; // Q should be set to 1
        #20; CLK = 1; #20; CLK = 0; #20;

        // Test Case 4: J=1, K=1 (Toggle)
        J = 1; K = 1; expected_Q = 0; // Q should toggle from 1 to 0
        #20; CLK = 1; #20; CLK = 0; #20;
        J = 1; K = 1; expected_Q = 1; // Q should toggle from 0 to 1
        #20; CLK = 1; #20; CLK = 0; #20;

        // Test Case 5: Active low RS (Reset)
        RS = 0; expected_Q = 0; // Q should be reset to 0
        #20; RS = 1; #20; // Return RS to high

        // Test Case 6: Active low SET (Set)
        SET = 0; expected_Q = 1; // Q should be set to 1
        #20; SET = 1; #20; // Return SET to high

        // End the simulation after all test cases
        J = 1'bz; K = 1'bz; // Tri-state J and K
        #20; CLK = 1; #20; CLK = 0; #20;

        // Stop the simulation
        #200; $stop;
    end

    // Optionally, you can add assertions to check if Q matches expected_Q
    // This is useful for formal verification and some simulators
    // always @(posedge CLK) begin
    //     assert(Q === expected_Q) else $display("Assertion failed: Q != expected_Q at time %0d", $time);
    // end

endmodule

