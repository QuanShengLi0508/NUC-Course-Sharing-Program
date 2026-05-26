library verilog;
use verilog.vl_types.all;
entity fenpin is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \out\           : out    vl_logic
    );
end fenpin;
