`timescale 1ns/1ps
module decoder3to8_tb;

reg       en;
reg [2:0] in;
wire[7:0] out;

integer i;

decoder3to8 u0 (
    .en(en),
    .in(in),
    .out(out)
);

initial begin
    en = 0; in = 3'b000; #10;
    en = 1;              #10;
    for (i = 0; i < 8; i = i + 1) begin
        in = i; #10;
    end
    en = 0;              #10;
    $display("Simulation Finished");
    $finish;
end

endmodule
