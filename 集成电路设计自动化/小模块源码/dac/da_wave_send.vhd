LIBRARY ieee;
   USE ieee.std_logic_1164.all;
   USE ieee.std_logic_unsigned.all;

ENTITY da_wave_send IS
   PORT (
      clk       : IN STD_LOGIC;
      rst_n     : IN STD_LOGIC;
      rd_addr   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      rd_data   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      rd_data2  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      rd_data3  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      rd_data4  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      da_clk    : OUT STD_LOGIC;
      da_data   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      in1       : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      in2       : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
   );
END da_wave_send;

ARCHITECTURE trans OF da_wave_send IS
   SIGNAL freq_cnt      : STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL freq_adj      : STD_LOGIC_VECTOR(7 DOWNTO 0);   
   SIGNAL rd_addr_xhdl0 : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
   rd_addr <= rd_addr_xhdl0;
   da_clk <= NOT(clk);
  freq_adj<= ("000000"&in2)+"00000001";
PROCESS (in1)
   BEGIN
         CASE in1 IS
            WHEN "00" =>
               da_data <= rd_data;
            WHEN "01" =>
               da_data <= rd_data2;
            WHEN "10" =>
               da_data <= rd_data3;
            WHEN "11" =>
               da_data <= rd_data4;
            WHEN others =>					
					da_data <= "XXXXXXXX";
         END CASE;
   END PROCESS;

 p1:  PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         freq_cnt <= "00000000";
			rd_addr_xhdl0<="00000000";	
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (freq_cnt = freq_adj) THEN
            freq_cnt <= "00000000";
				rd_addr_xhdl0<=rd_addr_xhdl0+1;
         ELSE
            freq_cnt <= freq_cnt + "00000001";
         END IF;
      END IF;
   END PROCESS;
END trans;
