
`timescale 1ns/1ns

module counter_tb;
  reg clk, reset;
  wire [3:0] out;

  counter i1(clk, reset, out);

  initial begin
    clk = 0;
    reset = 0;
    #50 reset = 1; 
  end

  always #100 clk = ~clk; 

  initial #2000 $stop; 

  
  initial $monitor($time,,,"clk=%d reset=%d out=%d", clk, reset, out);
endmodule
