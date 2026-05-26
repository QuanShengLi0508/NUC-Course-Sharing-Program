`timescale 1ns/1ns
//`include "fenpin.v"

module fenpin_tb;
    reg clk;
    reg rst;
  

    fenpin i1 (clk, rst, out);  // ?????

    initial begin
        clk = 1;
        rst = 0;
        #100 rst = 1;
    end

    always #200 clk =~clk;  // ??????

    initial #5000 $stop;  // ???5000ns???

    // ???$monitor????????????????
    initial $monitor($time, " clk=%b rst=%b out=%b", clk, rst, out);
endmodule

  