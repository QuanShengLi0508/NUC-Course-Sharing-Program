`timescale 1ns/1ns
`include "mux4_1.v" // ??mux4_1.v?????mux4_1??

module mux4_1_tp; // ??????

// ?????reg?
reg [1:0] sel;
reg in0, in1, in2, in3;

// ?????wire?
wire out;

// ???????4:1???????
mux4_1 uut (
    .out(out),
    .in0(in0),
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .sel(sel)
);

initial begin
    // Monitor the inputs, select lines, and output
    $monitor($time, " in0=%b, in1=%b, in2=%b, in3=%b, sel=%b, out=%b", in0, in1, in2, in3, sel, out);

    // Test Case 1: Select in0
    in0 = 0; in1 = 1; in2 = 1; in3 = 1; sel = 2'b00; #20; // Wait for 20 time units

    // Test Case 2: Select in1
    in0 = 1; in1 = 0; in2 = 1; in3 = 1; sel = 2'b01; #20;

    // Test Case 3: Select in2
    in0 = 1; in1 = 1; in2 = 0; in3 = 1; sel = 2'b10; #20;

    // Test Case 4: Select in3
    in0 = 1; in1 = 1; in2 = 1; in3 = 0; sel = 2'b11; #20;
    #100; // Wait for additional 100 time units before stopping (optional)
    $stop;
end

endmodule
