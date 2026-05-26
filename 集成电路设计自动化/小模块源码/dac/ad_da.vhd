library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity ad_da is
   port ( ad_data   : in    std_logic_vector (7 downto 0); 
          key1      : in    std_logic; 
          key2      : in    std_logic; 
          sys_clk   : in    std_logic; 
          sys_rst_n : in    std_logic; 
          ad_clk    : out   std_logic; 
          ad_out    : out   std_logic_vector (7 downto 0); 
          da_clk    : out   std_logic; 
          da_data   : out   std_logic_vector (7 downto 0));
end ad_da;

architecture BEHAVIORAL of ad_da_vhdl is
   attribute IOSTANDARD       : string ;
   attribute IBUF_DELAY_VALUE : string ;
   attribute BOX_TYPE         : string ;
   signal XLXN_1    : std_logic;
   signal XLXN_2    : std_logic;
   signal XLXN_37   : std_logic_vector (1 downto 0);
   signal XLXN_40   : std_logic_vector (1 downto 0);
   signal XLXN_47   : std_logic_vector (7 downto 0);
   signal XLXN_48   : std_logic_vector (7 downto 0);
   signal XLXN_49   : std_logic_vector (7 downto 0);
   signal XLXN_50   : std_logic_vector (7 downto 0);
   signal XLXN_51   : std_logic_vector (7 downto 0);
   signal XLXN_53   : std_logic;
   signal XLXN_55   : std_logic;
   component ad_wave_rec
      port ( clk     : in    std_logic; 
             rst_n   : in    std_logic; 
             ad_data : in    std_logic_vector (7 downto 0); 
             ad_clk  : out   std_logic; 
             ad_out  : out   std_logic_vector (7 downto 0));
   end component;
   
   component da_wave_send
      port ( clk      : in    std_logic; 
             rst_n    : in    std_logic; 
             rd_data  : in    std_logic_vector (7 downto 0); 
             rd_data2 : in    std_logic_vector (7 downto 0); 
             rd_data3 : in    std_logic_vector (7 downto 0); 
             rd_data4 : in    std_logic_vector (7 downto 0); 
             in1      : in    std_logic_vector (1 downto 0); 
             in2      : in    std_logic_vector (1 downto 0); 
             da_clk   : out   std_logic; 
             rd_addr  : out   std_logic_vector (7 downto 0); 
             da_data  : out   std_logic_vector (7 downto 0));
   end component;
   
   component counter
      port ( clk   : in    std_logic; 
             rst_n : in    std_logic; 
             q     : out   std_logic_vector (1 downto 0));
   end component;
   
   component IBUFG
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute IOSTANDARD of IBUFG : component is "DEFAULT";
   attribute IBUF_DELAY_VALUE of IBUFG : component is "0";
   attribute BOX_TYPE of IBUFG : component is "BLACK_BOX";
   
   component rom
      port ( addra : in    std_logic_vector (7 downto 0); 
             clka  : in    std_logic; 
             douta : out   std_logic_vector (7 downto 0));
   end component;
   
   component rom_saw
      port ( douta : out   std_logic_vector (7 downto 0); 
             addra : in    std_logic_vector (7 downto 0); 
             clka  : in    std_logic);
   end component;
   
   component rom_squ
      port ( addra : in    std_logic_vector (7 downto 0); 
             douta : out   std_logic_vector (7 downto 0); 
             clka  : in    std_logic);
   end component;
   
   component rom_tri
      port ( addra : in    std_logic_vector (7 downto 0); 
             clka  : in    std_logic; 
             douta : out   std_logic_vector (7 downto 0));
   end component;
   
   component BUFG
      port ( I : in    std_logic; 
             O : out   std_logic);
   end component;
   attribute BOX_TYPE of BUFG : component is "BLACK_BOX";
   
begin
   XLXI_1 : ad_wave_rec
      port map (ad_data(7 downto 0)=>ad_data(7 downto 0),
                clk=>XLXN_53,
                rst_n=>sys_rst_n,
                ad_clk=>ad_clk,
                ad_out(7 downto 0)=>ad_out(7 downto 0));
   
   XLXI_2 : da_wave_send
      port map (clk=>XLXN_55,
                in1(1 downto 0)=>XLXN_37(1 downto 0),
                in2(1 downto 0)=>XLXN_40(1 downto 0),
                rd_data(7 downto 0)=>XLXN_47(7 downto 0),
                rd_data2(7 downto 0)=>XLXN_48(7 downto 0),
                rd_data3(7 downto 0)=>XLXN_49(7 downto 0),
                rd_data4(7 downto 0)=>XLXN_50(7 downto 0),
                rst_n=>sys_rst_n,
                da_clk=>da_clk,
                da_data(7 downto 0)=>da_data(7 downto 0),
                rd_addr(7 downto 0)=>XLXN_51(7 downto 0));
   
   XLXI_3 : counter
      port map (clk=>XLXN_1,
                rst_n=>sys_rst_n,
                q(1 downto 0)=>XLXN_37(1 downto 0));
   
   XLXI_4 : counter
      port map (clk=>XLXN_2,
                rst_n=>sys_rst_n,
                q(1 downto 0)=>XLXN_40(1 downto 0));
   
   XLXI_14 : IBUFG
      port map (I=>key1,
                O=>XLXN_1);
   
   XLXI_15 : IBUFG
      port map (I=>key2,
                O=>XLXN_2);
   
   XLXI_16 : IBUFG
      port map (I=>sys_clk,
                O=>XLXN_55);
   
   XLXI_17 : rom
      port map (addra(7 downto 0)=>XLXN_51(7 downto 0),
                clka=>XLXN_55,
                douta(7 downto 0)=>XLXN_47(7 downto 0));
   
   XLXI_18 : rom_saw
      port map (addra(7 downto 0)=>XLXN_51(7 downto 0),
                clka=>XLXN_55,
                douta(7 downto 0)=>XLXN_48(7 downto 0));
   
   XLXI_19 : rom_squ
      port map (addra(7 downto 0)=>XLXN_51(7 downto 0),
                clka=>XLXN_55,
                douta(7 downto 0)=>XLXN_49(7 downto 0));
   
   XLXI_20 : rom_tri
      port map (addra(7 downto 0)=>XLXN_51(7 downto 0),
                clka=>XLXN_55,
                douta(7 downto 0)=>XLXN_50(7 downto 0));
   
   XLXI_22 : BUFG
      port map (I=>XLXN_55,
                O=>XLXN_53);
   
end BEHAVIORAL;
?
