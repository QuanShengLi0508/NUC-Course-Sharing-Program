LIBRARY ieee;
   USE ieee.std_logic_1164.all;

ENTITY ad_wave_rec IS
   PORT (
      clk      : IN STD_LOGIC;
      rst_n    : IN STD_LOGIC;
      ad_data  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      ad_clk   : OUT STD_LOGIC;
      ad_out   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
   );
END ad_wave_rec;

ARCHITECTURE trans OF ad_wave_rec IS

signal counter : integer range 0 to 1 :=0;
signal mid : STD_LOGIC;
signal ad_data1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ad_data2 : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
   PROCESS (clk, rst_n)
   BEGIN
      IF (rst_n = '0') THEN
         counter <= 0;
			mid <= '0';
      ELSIF (clk'EVENT AND clk = '1') THEN
         IF (counter = 1) THEN
			counter <= 0;
			mid <= NOT(mid);
			ad_out <= ad_data;
			ELSE
			counter <= counter +1;
      END IF;
		END IF;
   END PROCESS;
 ad_clk <= mid;
END trans;

