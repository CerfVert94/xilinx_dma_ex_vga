--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
--Date        : Thu Jan 16 05:39:18 2020
--Host        : localhost.localdomain running 64-bit unknown
--Command     : generate_target vga_controller.bd
--Design      : vga_controller
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity vga_controller is
  port (
    HSYNC_outp : out STD_LOGIC;
    VSYNC_outp : out STD_LOGIC;
    clk_VGA : in STD_LOGIC;
    clk_inp : in STD_LOGIC;
    clk_out : out STD_LOGIC;
    data_B_outp : out STD_LOGIC_VECTOR(3 downto 0);
    data_G_outp : out STD_LOGIC_VECTOR(3 downto 0);
    data_R_outp : out STD_LOGIC_VECTOR(3 downto 0);
    fft_act : in STD_LOGIC;
    hsync_inp : in STD_LOGIC;
    indic : in STD_LOGIC;
    reset_inp : in STD_LOGIC;
    reset_out : out STD_LOGIC;
    tempo_s : in STD_LOGIC_VECTOR ( 3 downto 0 );
    video_active_inp : in STD_LOGIC;
    vsync_inp : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of vga_controller : entity is "vga_controller,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=vga_controller,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=1,numReposBlks=0,numNonXlnxBlks=0,numHierBlks=1,maxHierDepth=1,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of vga_controller : entity is "vga_controller.hwdef";
end vga_controller;

architecture Behavioral of vga_controller is
    signal B_value      : std_logic_vector(3 downto 0);
  signal R_value      : std_logic_vector(3 downto 0);
  signal G_value      : std_logic_vector(3 downto 0);
	 
begin
hsync_outp <= hsync_inp;
vsync_outp <= vsync_inp;
clk_out <= clk_inp;
reset_out <= reset_inp;
rgb : process(tempo_s, video_active_inp, clk_inp, clk_VGA)
begin

    if ((fft_act = '1') and (video_active_inp = '1') and (indic = '1')) then 

        data_R_outp <= "0101";
        data_G_outp <= "0101";
        data_B_outp <= "1111";
    elsif ((fft_act = '1') and (video_active_inp = '1') and (indic = '0')) then 
        
                data_R_outp <= "1111";
                data_G_outp <= "0101";
                data_B_outp <= "0101";
    else
        data_R_outp <= "0000";
        data_G_outp <= "0000";
        data_B_outp <= "0000";
            
     end if;
  
end process;
end Behavioral;
