
################################################################
# This is a generated script based on design: vga_ex_dma
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source vga_ex_dma_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z020clg484-1
#    set_property BOARD_PART em.avnet.com:zed:part0:1.3 [current_project]

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name vga_ex_dma

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set HSYNC_outp [ create_bd_port -dir O HSYNC_outp ]
  set VSYNC_outp [ create_bd_port -dir O VSYNC_outp ]
  set clk_inp [ create_bd_port -dir I clk_inp ]
  set data_B_outp [ create_bd_port -dir O -from 3 -to 0 data_B_outp ]
  set data_G_outp [ create_bd_port -dir O -from 3 -to 0 data_G_outp ]
  set data_R_outp [ create_bd_port -dir O -from 3 -to 0 data_R_outp ]
  set locked [ create_bd_port -dir O locked ]
  set reset_inp [ create_bd_port -dir I -type rst reset_inp ]

  # Create instance: axi_dma_0, and set properties
  set axi_dma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 axi_dma_0 ]
  set_property -dict [ list \
CONFIG.c_include_mm2s {1} \
CONFIG.c_include_mm2s_dre {1} \
CONFIG.c_include_s2mm {0} \
CONFIG.c_include_s2mm_dre {0} \
CONFIG.c_include_sg {0} \
CONFIG.c_sg_include_stscntrl_strm {0} \
CONFIG.c_sg_length_width {23} \
 ] $axi_dma_0

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $axi_mem_intercon

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.2 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKOUT1_JITTER {127.691} \
CONFIG.CLKOUT1_PHASE_ERROR {97.646} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {108} \
CONFIG.CLK_IN1_BOARD_INTERFACE {sys_clock} \
CONFIG.MMCM_CLKFBOUT_MULT_F {10.125} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {9.375} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.USE_BOARD_FLOW {true} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
CONFIG.PCW_USE_S_AXI_GP0 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.preset {ZedBoard} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $processing_system7_0_axi_periph

  # Create instance: reset_synchronizer_wrapper_0, and set properties
  set reset_synchronizer_wrapper_0 [ create_bd_cell -type ip -vlnv user.org:user:reset_synchronizer_wrapper:1.0 reset_synchronizer_wrapper_0 ]

  # Create instance: rst_processing_system7_0_100M, and set properties
  set rst_processing_system7_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_100M ]

  # Create instance: vga_controller_wrapper_0, and set properties
  set vga_controller_wrapper_0 [ create_bd_cell -type ip -vlnv user.org:user:vga_controller_wrapper:1.0 vga_controller_wrapper_0 ]

  # Create instance: xvga_timing_controller_0, and set properties
  set xvga_timing_controller_0 [ create_bd_cell -type ip -vlnv user.org:user:xvga_timing_controller:1.0 xvga_timing_controller_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_dma_0_M_AXIS_MM2S [get_bd_intf_pins axi_dma_0/M_AXIS_MM2S] [get_bd_intf_pins xvga_timing_controller_0/S00_AXIS]
  connect_bd_intf_net -intf_net axi_dma_0_M_AXI_MM2S [get_bd_intf_pins axi_dma_0/M_AXI_MM2S] [get_bd_intf_pins axi_mem_intercon/S00_AXI]
  connect_bd_intf_net -intf_net axi_mem_intercon_M00_AXI [get_bd_intf_pins axi_mem_intercon/M00_AXI] [get_bd_intf_pins processing_system7_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_dma_0/S_AXI_LITE] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]

  # Create port connections
  connect_bd_net -net axi_dma_0_m_axis_mm2s_tkeep [get_bd_pins axi_dma_0/m_axis_mm2s_tkeep] [get_bd_pins xvga_timing_controller_0/s00_axis_tstrb]
  connect_bd_net -net axi_dma_0_mm2s_introut [get_bd_pins axi_dma_0/mm2s_introut] [get_bd_pins processing_system7_0/IRQ_F2P]
  connect_bd_net -net clk_inp_1 [get_bd_ports clk_inp] [get_bd_pins vga_controller_wrapper_0/clk_inp]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins reset_synchronizer_wrapper_0/dest_clk] [get_bd_pins vga_controller_wrapper_0/clk_VGA] [get_bd_pins xvga_timing_controller_0/clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_dma_0/m_axi_mm2s_aclk] [get_bd_pins axi_dma_0/s_axi_lite_aclk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0/S_AXI_HP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_100M/slowest_sync_clk] [get_bd_pins xvga_timing_controller_0/s00_axis_aclk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_100M/ext_reset_in]
  connect_bd_net -net reset_inp_1 [get_bd_ports reset_inp] [get_bd_pins vga_controller_wrapper_0/reset_inp]
  connect_bd_net -net reset_synchronizer_wrapper_0_dest_rst [get_bd_pins reset_synchronizer_wrapper_0/dest_rst] [get_bd_pins xvga_timing_controller_0/reset]
  connect_bd_net -net rst_processing_system7_0_100M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_100M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_100M_peripheral_aresetn [get_bd_pins axi_dma_0/axi_resetn] [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_100M/peripheral_aresetn] [get_bd_pins xvga_timing_controller_0/s00_axis_aresetn]
  connect_bd_net -net vga_controller_wrapper_0_HSYNC_outp [get_bd_ports HSYNC_outp] [get_bd_pins vga_controller_wrapper_0/HSYNC_outp]
  connect_bd_net -net vga_controller_wrapper_0_VSYNC_outp [get_bd_ports VSYNC_outp] [get_bd_pins vga_controller_wrapper_0/VSYNC_outp]
  connect_bd_net -net vga_controller_wrapper_0_clk_out [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins vga_controller_wrapper_0/clk_out] [get_bd_pins xvga_timing_controller_0/clk_100MHz_inp]
  connect_bd_net -net vga_controller_wrapper_0_data_B_outp [get_bd_ports data_B_outp] [get_bd_pins vga_controller_wrapper_0/data_B_outp]
  connect_bd_net -net vga_controller_wrapper_0_data_G_outp [get_bd_ports data_G_outp] [get_bd_pins vga_controller_wrapper_0/data_G_outp]
  connect_bd_net -net vga_controller_wrapper_0_data_R_outp [get_bd_ports data_R_outp] [get_bd_pins vga_controller_wrapper_0/data_R_outp]
  connect_bd_net -net vga_controller_wrapper_0_reset_out [get_bd_pins reset_synchronizer_wrapper_0/src_rst] [get_bd_pins vga_controller_wrapper_0/reset_out] [get_bd_pins xvga_timing_controller_0/rst_inp]
  connect_bd_net -net xvga_timing_controller_0_fft_act [get_bd_pins vga_controller_wrapper_0/fft_act] [get_bd_pins xvga_timing_controller_0/fft_act]
  connect_bd_net -net xvga_timing_controller_0_hsync_outp [get_bd_pins vga_controller_wrapper_0/hsync_inp] [get_bd_pins xvga_timing_controller_0/hsync_outp]
  connect_bd_net -net xvga_timing_controller_0_indic [get_bd_pins vga_controller_wrapper_0/indic] [get_bd_pins xvga_timing_controller_0/indic]
  connect_bd_net -net xvga_timing_controller_0_tempo_s [get_bd_pins vga_controller_wrapper_0/tempo_s] [get_bd_pins xvga_timing_controller_0/tempo_s]
  connect_bd_net -net xvga_timing_controller_0_video_active_outp [get_bd_pins vga_controller_wrapper_0/video_active_inp] [get_bd_pins xvga_timing_controller_0/video_active_outp]
  connect_bd_net -net xvga_timing_controller_0_vsync_outp [get_bd_pins vga_controller_wrapper_0/vsync_inp] [get_bd_pins xvga_timing_controller_0/vsync_outp]

  # Create address segments
  create_bd_addr_seg -range 0x20000000 -offset 0x0 [get_bd_addr_spaces axi_dma_0/Data_MM2S] [get_bd_addr_segs processing_system7_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_processing_system7_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x10000 -offset 0x40400000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_dma_0/S_AXI_LITE/Reg] SEG_axi_dma_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.8
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 240 -defaultsOSRD
preplace port clk_inp -pg 1 -y 540 -defaultsOSRD
preplace port reset_inp -pg 1 -y 640 -defaultsOSRD
preplace port locked -pg 1 -y 20 -defaultsOSRD
preplace port VSYNC_outp -pg 1 -y 580 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 260 -defaultsOSRD
preplace port HSYNC_outp -pg 1 -y 560 -defaultsOSRD
preplace portBus data_B_outp -pg 1 -y 620 -defaultsOSRD
preplace portBus data_R_outp -pg 1 -y 660 -defaultsOSRD
preplace portBus data_G_outp -pg 1 -y 640 -defaultsOSRD
preplace inst reset_synchronizer_wrapper_0 -pg 1 -lvl 3 -y 800 -defaultsOSRD
preplace inst axi_dma_0 -pg 1 -lvl 3 -y 140 -defaultsOSRD
preplace inst xvga_timing_controller_0 -pg 1 -lvl 4 -y 700 -defaultsOSRD
preplace inst rst_processing_system7_0_100M -pg 1 -lvl 1 -y 450 -defaultsOSRD
preplace inst vga_controller_wrapper_0 -pg 1 -lvl 5 -y 620 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 2 -y 690 -defaultsOSRD
preplace inst axi_mem_intercon -pg 1 -lvl 4 -y 310 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 2 -y 310 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 5 -y 320 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 5 1 NJ
preplace netloc xvga_timing_controller_0_video_active_outp 1 4 1 1520
preplace netloc vga_controller_wrapper_0_clk_out 1 1 5 320 740 NJ 740 1100 820 NJ 820 1990
preplace netloc axi_dma_0_m_axis_mm2s_tkeep 1 3 1 1040
preplace netloc vga_controller_wrapper_0_reset_out 1 2 4 650 860 1110 830 NJ 830 1980
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 2 1 650
preplace netloc processing_system7_0_M_AXI_GP0 1 1 5 330 10 NJ 10 NJ 10 NJ 10 1990
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 6 -40 30 NJ 30 NJ 30 NJ 30 NJ 30 2000
preplace netloc axi_mem_intercon_M00_AXI 1 4 1 1470
preplace netloc xvga_timing_controller_0_indic 1 4 1 1500
preplace netloc vga_controller_wrapper_0_HSYNC_outp 1 5 1 NJ
preplace netloc vga_controller_wrapper_0_data_R_outp 1 5 1 NJ
preplace netloc vga_controller_wrapper_0_data_G_outp 1 5 1 NJ
preplace netloc reset_inp_1 1 0 5 NJ 580 NJ 580 NJ 580 NJ 580 NJ
preplace netloc rst_processing_system7_0_100M_peripheral_aresetn 1 1 3 320 170 660 50 1060
preplace netloc xvga_timing_controller_0_tempo_s 1 4 1 1510
preplace netloc reset_synchronizer_wrapper_0_dest_rst 1 3 1 1080
preplace netloc axi_dma_0_M_AXI_MM2S 1 3 1 1110
preplace netloc vga_controller_wrapper_0_VSYNC_outp 1 5 1 NJ
preplace netloc processing_system7_0_FIXED_IO 1 5 1 NJ
preplace netloc axi_dma_0_mm2s_introut 1 3 2 NJ 430 1470
preplace netloc xvga_timing_controller_0_hsync_outp 1 4 1 1490
preplace netloc clk_wiz_0_clk_out1 1 2 3 650 670 1070 530 NJ
preplace netloc rst_processing_system7_0_100M_interconnect_aresetn 1 1 3 330 430 NJ 290 NJ
preplace netloc processing_system7_0_FCLK_CLK0 1 0 6 -30 350 310 150 640 40 1090 190 1480 190 1980
preplace netloc xvga_timing_controller_0_vsync_outp 1 4 1 1530
preplace netloc axi_dma_0_M_AXIS_MM2S 1 3 1 1080
preplace netloc xvga_timing_controller_0_fft_act 1 4 1 1480
preplace netloc vga_controller_wrapper_0_data_B_outp 1 5 1 NJ
preplace netloc clk_inp_1 1 0 5 NJ 540 NJ 540 NJ 540 NJ 540 NJ
levelinfo -pg 1 -60 140 490 860 1310 1760 2020 -top 0 -bot 880
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


