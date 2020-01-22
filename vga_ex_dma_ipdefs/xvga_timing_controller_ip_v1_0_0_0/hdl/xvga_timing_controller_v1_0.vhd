library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xvga_timing_controller_v1_0 is
	generic (
		-- Users to add parameters here
        
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 32
	);
	port (
		-- Users to add ports here
          clk : in STD_LOGIC;
          clk_100MHz_inp : in STD_LOGIC;
          reset : in STD_LOGIC;
          rst_inp : in STD_LOGIC;
          fft_act : out STD_LOGIC;
          hsync_outp : out STD_LOGIC;
          indic : out STD_LOGIC;
          tempo_s : out STD_LOGIC_VECTOR ( 3 downto 0 );
          video_active_outp : out STD_LOGIC;
          vsync_outp : out STD_LOGIC;
		-- User ports ends
		-- Do not modify the ports beyond this line
        

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic
	);
end xvga_timing_controller_v1_0;

architecture arch_imp of xvga_timing_controller_v1_0 is

	-- component declaration
	component xvga_timing_controller_v1_0_S00_AXIS is
		generic (
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
		);
		port (
      clk : in STD_LOGIC;
        clk_100MHz_inp : in STD_LOGIC;
        reset : in STD_LOGIC;
        rst_inp : in STD_LOGIC;
        fft_act : out STD_LOGIC;
        hsync_outp : out STD_LOGIC;
        indic : out STD_LOGIC;
        tempo_s : out STD_LOGIC_VECTOR ( 3 downto 0 );
        video_active_outp : out STD_LOGIC;
        vsync_outp : out STD_LOGIC;
		S_AXIS_ACLK	: in std_logic;
		S_AXIS_ARESETN	: in std_logic;
		S_AXIS_TREADY	: out std_logic;
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		S_AXIS_TLAST	: in std_logic;
		S_AXIS_TVALID	: in std_logic
		);
	end component xvga_timing_controller_v1_0_S00_AXIS;

begin

-- Instantiation of Axi Bus Interface S00_AXIS
xvga_timing_controller_v1_0_S00_AXIS_inst : xvga_timing_controller_v1_0_S00_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
	    clk => clk,
        clk_100MHz_inp => clk_100MHz_inp,
        reset => reset,
        rst_inp => rst_inp,
        fft_act => fft_act,
        hsync_outp => hsync_outp,
        indic => indic,
        tempo_s => tempo_s,
        video_active_outp => video_active_outp,
        vsync_outp => vsync_outp,
		S_AXIS_ACLK	=> s00_axis_aclk,
		S_AXIS_ARESETN	=> s00_axis_aresetn,
		S_AXIS_TREADY	=> s00_axis_tready,
		S_AXIS_TDATA	=> s00_axis_tdata,
		S_AXIS_TSTRB	=> s00_axis_tstrb,
		S_AXIS_TLAST	=> s00_axis_tlast,
		S_AXIS_TVALID	=> s00_axis_tvalid
	);

	-- Add user logic here

	-- User logic ends

end arch_imp;
