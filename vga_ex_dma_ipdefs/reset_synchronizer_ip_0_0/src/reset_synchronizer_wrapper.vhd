--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (lin64) Build 1412921 Wed Nov 18 09:44:32 MST 2015
--Date        : Thu Jan 16 05:14:03 2020
--Host        : localhost.localdomain running 64-bit unknown
--Command     : generate_target reset_synchronizer_wrapper.bd
--Design      : reset_synchronizer_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity reset_synchronizer_wrapper is
  port (
    dest_clk : in STD_LOGIC;
    dest_rst : out STD_LOGIC;
    src_rst : in STD_LOGIC
  );
end reset_synchronizer_wrapper;

architecture STRUCTURE of reset_synchronizer_wrapper is
  component reset_synchronizer is
  port (
    dest_rst : out STD_LOGIC;
    src_rst : in STD_LOGIC;
    dest_clk : in STD_LOGIC
  );
  end component reset_synchronizer;
begin
reset_synchronizer_i: component reset_synchronizer
     port map (
      dest_clk => dest_clk,
      dest_rst => dest_rst,
      src_rst => src_rst
    );
end STRUCTURE;
