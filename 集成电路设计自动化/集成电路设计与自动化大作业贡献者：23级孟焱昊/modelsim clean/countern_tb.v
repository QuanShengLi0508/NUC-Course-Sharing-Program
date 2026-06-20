`timescale 1ns/1ns
module counter_tb;
  reg clk,reset;
  wire[3:0] out;
  counter i1(clk,reset,out);
  initial
  begin
    clk=0;
    reset=1;    #300 reset=0;
  end
  always  #200clk=~clk;
initial  #5000 $stop;
  initial $monitor($time,,,"clk=%d reset=%d out=%d",clk,reset,out);
   endmodule

