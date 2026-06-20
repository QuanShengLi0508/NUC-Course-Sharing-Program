`timescale 1ns/1ps
module decoder3to8 (
    input  wire       en,
    input  wire [2:0] in,
    output reg  [7:0] out
);

always @(*) begin
    if (!en)
        out = 8'b1111_1111;
    else begin
        case (in)
            3'd0: out = 8'b1111_1110;
            3'd1: out = 8'b1111_1101;
            3'd2: out = 8'b1111_1011;
            3'd3: out = 8'b1111_0111;
            3'd4: out = 8'b1110_1111;
            3'd5: out = 8'b1101_1111;
            3'd6: out = 8'b1011_1111;
            3'd7: out = 8'b0111_1111;
            default: out = 8'b1111_1111;
        endcase
    end
end

endmodule
