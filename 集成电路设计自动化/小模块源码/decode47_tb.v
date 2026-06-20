`timescale 1ns/1ns

`include "decode47.v"

module decode47_tb;

    reg D3,D2,D1,D0;
    
    wire a,b,c,d,e,f,g;
    integer i;//

    decode47 adder(a,b,c,d,e,f,g,D3,D2,D1,D0);

   


    // ??????a??
    initial begin
        D3 = 0; D2 = 0; D1 = 0; D0 = 0;

        for (i = 1; i < 16; i = i + 1)
        #10
        {D3,D2,D1,D0}= i;
    end

    
    // ????
    initial begin
        $monitor($time, " %b%b%b%b,%b%b%b%b%b%b%b", 
        D3,D2,D1,D0,a,b,c,d,e,f,g);
        #200 $stop;
    end
endmodule