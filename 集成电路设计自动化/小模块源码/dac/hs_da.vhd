LIBRARY ieee;
   USE ieee.std_logic_1164.all;
ENTITY hs_da IS
   PORT (
      sys_clk    : IN STD_LOGIC;
      sys_rst_n  : IN STD_LOGIC;
      da_clk     : OUT STD_LOGIC;
      da_data    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      key1       : IN STD_LOGIC;
      key2       : IN STD_LOGIC
   );
END hs_da;

ARCHITECTURE trans OF hs_da IS

   COMPONENT da_wave_send IS
      PORT (
         clk        : IN STD_LOGIC;
         rst_n      : IN STD_LOGIC;
         rd_addr    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         rd_data    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         rd_data2   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         rd_data3   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         rd_data4   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         da_clk     : OUT STD_LOGIC;
         da_data    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
         in1        : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
         in2        : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
      );
   END COMPONENT;

   COMPONENT rom IS
      PORT (
         clka : IN STD_LOGIC;
         addra : IN STD_LOGIC_vector(7 downto 0);
         douta  : out STD_LOGIC_vector(7 downto 0)
      );
   END COMPONENT;

   COMPONENT rom_tri IS
      PORT (
         clka : IN STD_LOGIC;
         addra : IN STD_LOGIC_vector(7 downto 0);
         douta  : out STD_LOGIC_vector(7 downto 0)
      );
   END COMPONENT;	

   COMPONENT rom_saw IS
      PORT (
         clka : IN STD_LOGIC;
         addra : IN STD_LOGIC_vector(7 downto 0);
         douta  : out STD_LOGIC_vector(7 downto 0)
      );
   END COMPONENT;	

   COMPONENT rom_squ IS
      PORT (
         clka : IN STD_LOGIC;
         addra : IN STD_LOGIC_vector(7 downto 0);
         douta  : out STD_LOGIC_vector(7 downto 0)
      );
   END COMPONENT;		

		   COMPONENT counter IS
      PORT (
         clk : IN STD_LOGIC;
         rst_n : IN STD_LOGIC;
         q : out STD_LOGIC_vector(1 downto 0)
      );
   END COMPONENT;			

	   COMPONENT IBUFG IS
      PORT (
         o : out STD_LOGIC;
         i : IN STD_LOGIC
      );
   END COMPONENT;		

   SIGNAL rd_addr       : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL rd_data       : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL rd_data2      : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL rd_data3      : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL rd_data4      : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL in1           : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL in2           : STD_LOGIC_VECTOR(1 DOWNTO 0);
   SIGNAL sys_clk_buff  : STD_LOGIC;
   SIGNAL sys_clk_buff1 : STD_LOGIC;
   SIGNAL key1o         : STD_LOGIC;
   SIGNAL key2o         : STD_LOGIC;
   SIGNAL ad_out        : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL da_clk_xhdl0  : STD_LOGIC;
   SIGNAL da_data_xhdl1 : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
   da_clk <= da_clk_xhdl0;
   da_data <= da_data_xhdl1;

   u_rom : rom
      PORT MAP (
         clka   => sys_clk_buff,
         addra  => rd_addr,
         douta  => rd_data
      );

   u_rom2 : rom_squ
      PORT MAP (
         clka   => sys_clk_buff,
         addra  => rd_addr,
         douta  => rd_data2
      );
   
   u_rom3 : rom_tri
      PORT MAP (
         clka   => sys_clk_buff,
         addra  => rd_addr,
         douta  => rd_data3
      );
   
   u_rom4 : rom_saw
      PORT MAP (
         clka   => sys_clk_buff,
         addra  => rd_addr,
         douta  => rd_data4
      );
   
   u_da_wave_send : da_wave_send
      PORT MAP (
         clk       => sys_clk_buff,
         rst_n     => sys_rst_n,
         rd_addr   => rd_addr,
         rd_data   => rd_data,
         rd_data2  => rd_data2,
         rd_data3  => rd_data3,
         rd_data4  => rd_data4,
         da_clk    => da_clk_xhdl0,
         da_data   => da_data_xhdl1,
         in1       => in1,
         in2       => in2
      );
   
   u_counter1 : counter
      PORT MAP (
         clk    => key1o,
         rst_n  => sys_rst_n,
         q      => in1
      );
   
   u_counter2 : counter
      PORT MAP (
         clk    => key2o,
         rst_n  => sys_rst_n,
         q      => in2
      );
   
   IBUFG_inst1 : IBUFG
      PORT MAP (
         o  => sys_clk_buff,
         i  => sys_clk
      );
   
   IBUFG_inst2 : IBUFG
      PORT MAP (
         o  => key1o,
         i  => key1
      );
   
   IBUFG_inst3 : IBUFG
      PORT MAP (
         o  => key2o,
         i  => key2
      );
   
END trans;
