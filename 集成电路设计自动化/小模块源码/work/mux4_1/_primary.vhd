library verilog;
use verilog.vl_types.all;
entity mux4_1 is
    port(
        \out\           : out    vl_logic;
        in0             : in     vl_logic;
        in1             : in     vl_logic;
        in2             : in     vl_logic;
        in3             : in     vl_logic;
        sel             : in     vl_logic_vector(1 downto 0)
    );
end mux4_1;
