library verilog;
use verilog.vl_types.all;
entity JK_FF is
    port(
        CLK             : in     vl_logic;
        J               : in     vl_logic;
        K               : in     vl_logic;
        Q               : out    vl_logic;
        RS              : in     vl_logic;
        SET             : in     vl_logic
    );
end JK_FF;
