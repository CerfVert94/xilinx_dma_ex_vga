--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
--Date        : Thu Jan 16 05:39:18 2020
--Host        : localhost.localdomain running 64-bit unknown
--Command     : generate_target vga_controller_wrapper.bd
--Design      : vga_controller_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity vga_controller_wrapper is
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
end vga_controller_wrapper;

architecture STRUCTURE of vga_controller_wrapper is
  component vga_controller is
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
  end component vga_controller;
begin
vga_controller_i: component vga_controller
     port map (
      HSYNC_outp => HSYNC_outp,
      VSYNC_outp => VSYNC_outp,
      clk_VGA => clk_VGA,
      clk_inp => clk_inp,
      clk_out => clk_out,
      data_B_outp => data_B_outp,
      data_G_outp => data_G_outp,
      data_R_outp => data_R_outp,
      fft_act => fft_act,
      hsync_inp => hsync_inp,
      indic => indic,
      reset_inp => reset_inp,
      reset_out => reset_out,
      tempo_s(3 downto 0) => tempo_s(3 downto 0),
      video_active_inp => video_active_inp,
      vsync_inp => vsync_inp
    );
end STRUCTURE;
