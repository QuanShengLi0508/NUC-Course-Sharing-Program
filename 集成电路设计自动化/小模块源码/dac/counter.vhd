library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;
entity counter is
    Port ( clk : in  STD_LOGIC;
           rst_n : in  STD_LOGIC;
           q : out  STD_LOGIC_VECTOR (1 downto 0));
end counter;

architecture Behavioral of counter is
signal tempcounter: std_logic_vector(1 downto 0);
begin
q<=tempcounter;

process(rst_n,clk)
 begin
   if(rst_n='0') then
	    tempcounter<="00";
    elsif(clk' event and clk='0') then
	    tempcounter<=tempcounter+1;
		 end if;
 end process ;
end Behavioral;
