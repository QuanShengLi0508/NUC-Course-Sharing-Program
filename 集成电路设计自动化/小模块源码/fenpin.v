module fenpin(clk,rst,out);
  input clk;
  input rst;
  output out;
 reg out;
  always @(posedge clk) begin
        if (!rst) begin
            out <= 0;    // ????????????0
        end else begin
            out <= ~out; // ???????
        end
    end
endmodule