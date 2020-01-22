--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
--Date        : Thu Jan 16 05:14:02 2020
--Host        : localhost.localdomain running 64-bit unknown
--Command     : generate_target reset_synchronizer.bd
--Design      : reset_synchronizer
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity reset_synchronizer is
    Generic(
        DEST_SYNC_FF_gen    : INTEGER := 2 -- Nb FF stages (2 - 10)
    );
  port (
    dest_clk : in STD_LOGIC;
    dest_rst : out STD_LOGIC;
    src_rst : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of reset_synchronizer : entity is "reset_synchronizer,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=reset_synchronizer,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=0,numNonXlnxBlks=0,numHierBlks=1,maxHierDepth=1,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of reset_synchronizer : entity is "reset_synchronizer.hwdef";
end reset_synchronizer;

architecture Behavioral of reset_synchronizer is

signal syncstages_ff : STD_LOGIC_VECTOR ( DEST_SYNC_FF_gen-1 downto 0 );
attribute ASYNC_REG : string;
attribute ASYNC_REG of syncstages_ff : signal is "true";
attribute RTL_KEEP : string;
attribute RTL_KEEP of syncstages_ff : signal is "true";

begin

gen_syncstages_ff: for I in 0 to DEST_SYNC_FF_gen-1 generate
    process(dest_clk)
    begin
        if(rising_edge(dest_clk)) then
            if(I = 0) then
                syncstages_ff(0)    <= src_rst;
            else
                syncstages_ff(I)    <= syncstages_ff(I-1);
            end if;
        end if;
    end process;
end generate;

dest_rst    <= syncstages_ff(DEST_SYNC_FF_gen-1);



end Behavioral;
