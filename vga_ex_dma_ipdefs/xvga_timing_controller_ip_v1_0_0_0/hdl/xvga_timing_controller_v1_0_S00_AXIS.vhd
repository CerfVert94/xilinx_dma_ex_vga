library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xvga_timing_controller_v1_0_S00_AXIS is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- AXI4Stream sink: Data Width
		C_S_AXIS_TDATA_WIDTH	: integer	:= 32
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

		-- AXI4Stream sink: Clock
		S_AXIS_ACLK	: in std_logic;
		-- AXI4Stream sink: Reset
		S_AXIS_ARESETN	: in std_logic;
		-- Ready to accept data in
		S_AXIS_TREADY	: out std_logic;
		-- Data in
		S_AXIS_TDATA	: in std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
		-- Byte qualifier
		S_AXIS_TSTRB	: in std_logic_vector((C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
		-- Indicates boundary of last packet
		S_AXIS_TLAST	: in std_logic;
		-- Data is in valid
		S_AXIS_TVALID	: in std_logic
	);
end xvga_timing_controller_v1_0_S00_AXIS;

architecture arch_imp of xvga_timing_controller_v1_0_S00_AXIS is
	
    
	-- function called clogb2 that returns an integer which has the 
    -- value of the ceiling of the log base 2.
	function clogb2 (bit_depth : integer) return integer is 
	variable depth  : integer := bit_depth;
	  begin
	    if (depth = 0) then
	      return(0);
	    else
	      for clogb2 in 1 to bit_depth loop  -- Works for up to 32 bit integers
	        if(depth <= 1) then 
	          return(clogb2);      
	        else
	          depth := depth / 2;
	        end if;
	      end loop;
	    end if;
	end;    

	-- Total number of input data.
	constant NUMBER_OF_INPUT_WORDS  : integer := 32;
	-- bit_num gives the minimum number of bits needed to address 'NUMBER_OF_INPUT_WORDS' size of FIFO.
	constant bit_num  : integer := clogb2(NUMBER_OF_INPUT_WORDS - 1);
	-- Define the states of state machine
	-- The control state machine oversees the writing of input streaming data to the FIFO,
	-- and outputs the streaming data from the FIFO
	type state is ( IDLE,        -- This is the initial/idle state 
	                WRITE_FIFO); -- In this state FIFO is written with the
	                             -- input stream data S_AXIS_TDATA 
	signal axis_tready	: std_logic;
	-- State variable
	signal  mst_exec_state : state;  
	-- FIFO implementation signals
	signal  byte_index : integer;    
	-- FIFO write enable
	signal fifo_wren : std_logic;
	-- FIFO full flag
	signal fifo_full_flag : std_logic;
	-- FIFO write pointer
	signal write_pointer : integer range 0 to bit_num-1 ;
	-- sink has accepted all the streaming data and stored in FIFO
	signal writes_done : std_logic;

	type BYTE_FIFO_TYPE is array (0 to (NUMBER_OF_INPUT_WORDS-1)) of std_logic_vector(((C_S_AXIS_TDATA_WIDTH/4)-1)downto 0);
	
	
	constant H_DISPLAY_cste     : INTEGER   := 1280; -- Nb Active Pixels Per Line
    constant H_FP_cste          : INTEGER   := 48;  -- Nb clocks front proch
    constant H_PULSE_cste       : INTEGER   := 112;  -- Nb clocks horizontal sync
    constant H_BP_cste          : INTEGER   := 248;  -- Nb clocks back proch
    constant V_DISPLAY_cste     : INTEGER   := 1024; -- Nb Active Line Per Frame
    constant V_FP_cste          : INTEGER   := 1;    -- Nb Lines front proch
    constant V_PULSE_cste       : INTEGER   := 3;    -- Nb Lines horizontal sync
    constant V_BP_cste          : INTEGER   := 38;   -- Nb Lines back proch
    
    -- Computations
    constant H_START_PULSE_cste : INTEGER := H_DISPLAY_cste + H_FP_cste;
    constant H_END_PULSE_cste   : INTEGER := H_START_PULSE_cste + H_PULSE_cste;
    constant V_START_PULSE_cste : INTEGER := V_DISPLAY_cste + V_FP_cste;
    constant V_END_PULSE_cste   : INTEGER := V_START_PULSE_cste + V_PULSE_cste;
    constant H_PERIOD_cste      : INTEGER := H_DISPLAY_cste + H_FP_cste + H_PULSE_cste + H_BP_cste;  -- number of pixel clocks per line
    constant V_PERIOD_cste      : INTEGER := V_DISPLAY_cste + V_FP_cste + V_PULSE_cste + V_BP_cste;  -- number of lines per frame
    signal change               : STD_LOGIC;
    
    signal counter_pixel_sig    : INTEGER RANGE 0 TO H_PERIOD_cste - 1 := 0;
    signal counter_line_sig     : INTEGER RANGE 0 TO V_PERIOD_cste - 1 := 0;
    signal indice               : INTEGER;
    
    type mytab is array(H_DISPLAY_cste - 1 downto 0) of integer;
    signal tab : mytab;	
    signal tab_pointer : integer range 0 to H_DISPLAY_cste - 1;

begin
	-- I/O Connections assignments

	S_AXIS_TREADY	<= axis_tready;
	-- Control state machine implementation
	process(S_AXIS_ACLK)
	begin
	  if (rising_edge (S_AXIS_ACLK)) then
	    if(S_AXIS_ARESETN = '0') then
	      -- Synchronous reset (active low)
	      mst_exec_state      <= IDLE;
	    else
	      case (mst_exec_state) is
	        when IDLE     => 
	          -- The sink starts accepting tdata when 
	          -- there tvalid is asserted to mark the
	          -- presence of valid streaming data 
	          if (S_AXIS_TVALID = '1')then
	            mst_exec_state <= WRITE_FIFO;
	          else
	            mst_exec_state <= IDLE;
	          end if;
	      
	        when WRITE_FIFO => 
	          -- When the sink has accepted all the streaming input data,
	          -- the interface swiches functionality to a streaming master
	          if (writes_done = '1') then
	            mst_exec_state <= IDLE;
	          else
	            -- The sink accepts and stores tdata 
	            -- into FIFO
	            mst_exec_state <= WRITE_FIFO;
	          end if;
	        
	        when others    => 
	          mst_exec_state <= IDLE;
	        
	      end case;
	    end if;  
	  end if;
	end process;
	-- AXI Streaming Sink 
	-- 
	-- The example design sink is always ready to accept the S_AXIS_TDATA  until
	-- the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	axis_tready <= '1' when ((mst_exec_state = WRITE_FIFO) and (write_pointer <= NUMBER_OF_INPUT_WORDS-1)) else '0';

	process(S_AXIS_ACLK)
	begin
	  if (rising_edge (S_AXIS_ACLK)) then
	    if(S_AXIS_ARESETN = '0') then
	      write_pointer <= 0;
	      writes_done <= '0';
	    else
	      if (write_pointer <= NUMBER_OF_INPUT_WORDS-1) then
	        if (fifo_wren = '1') then
	          -- write pointer is incremented after every write to the FIFO
	          -- when FIFO write signal is enabled.
	          write_pointer <= write_pointer + 1;
	          if tab_pointer < H_DISPLAY_cste then
	           tab_pointer <= tab_pointer + 1;
	          else
	           tab_pointer <= 0;
	          end if;
	          writes_done <= '0';
	        end if;
	        if ((write_pointer = NUMBER_OF_INPUT_WORDS-1) or S_AXIS_TLAST = '1') then
	          -- reads_done is asserted when NUMBER_OF_INPUT_WORDS numbers of streaming data 
	          -- has been written to the FIFO which is also marked by S_AXIS_TLAST(kept for optional usage).
	          writes_done <= '1';
	        end if;
	      end  if;
	    end if;
	  end if;
	end process;

	-- FIFO write enable generation
	fifo_wren <= S_AXIS_TVALID and axis_tready;

	-- FIFO Implementation
--	 FIFO_GEN: for byte_index in 0 to (C_S_AXIS_TDATA_WIDTH/8-1) generate

--	 signal stream_data_fifo : BYTE_FIFO_TYPE;
--	 begin   
	  -- Streaming input data is stored in FIFO
	  process(S_AXIS_ACLK)
	  begin
	    if (rising_edge (S_AXIS_ACLK)) then
	      if (fifo_wren = '1') then
	        --stream_data_fifo(write_pointer) <= S_AXIS_TDATA((byte_index*8+7) downto (byte_index*8));
	        tab(tab_pointer) <= to_integer(unsigned(S_AXIS_TDATA(31 downto 0)));
	        --tab(write_pointer) <= write_pointer;
	      end if;  
	    end  if;
	  end process;

--	end generate FIFO_GEN;

	-- Add user logic here
    
    main_proc : process(clk)
    begin
        if(rising_edge(clk))then
            if(reset = '1') then
                hsync_outp          <= '0';
                vsync_outp          <= '0';
                video_active_outp   <= '0';
            else
                -- Dirac function is displayed in deep blue (1) / red (0)
                indic <= '1';
                --if (change = '0') then
                --else 
                  --  indic <= '0';
                --end if;
                
                --if ((H_display_cste = counter_pixel_sig) and (V_display_cste = counter_line_sig) and (change = '1'))then
                --    change <= '0';
                --elsif ((H_display_cste = counter_pixel_sig) and (V_display_cste = counter_line_sig) and (change = '0'))then
                --    change <= '1';                     
                --end if;
                
                -- Start HSYNC Pulse
                if(counter_pixel_sig = H_START_PULSE_cste-1) then
                    hsync_outp <= '0';
                -- End HSYNC Pulse
                elsif(counter_pixel_sig = H_END_PULSE_cste-1) then
                    hsync_outp <= '1';
                end if;
                
                -- Start VSYNC Pulse
                if(counter_pixel_sig = H_PERIOD_cste-1) and (counter_line_sig = V_START_PULSE_cste-1) then
                    VSYNC_outp <= '1';
                -- End VSYNC Pulse
                elsif(counter_pixel_sig = H_PERIOD_cste-1) and (counter_line_sig = V_END_PULSE_cste-1) then
                    VSYNC_outp  <= '0';
                end if;
                
                -- WILL BE DEPRECATED.
                if ((counter_line_sig > 110) and (counter_line_sig < 300)) then
                      tempo_s <= "0001";
                else 
                      tempo_s <= "0000"; 
                end if;
                
               indice <= counter_pixel_sig;          
               
               if (counter_line_sig > V_DISPLAY_cste - tab(indice)) then
                    fft_act <= '1';
               else 
                    fft_act <= '0';
               end if;
                                         
                -- Active video
            
                if((counter_line_sig < V_DISPLAY_cste) and (counter_pixel_sig < H_DISPLAY_cste)) then
                    video_active_outp   <= '1';
                -- Blank periods
                else
                    video_active_outp   <= '0';
                end if;
            end if;
        end if;
    end process;
    
    counter_proc : process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset = '1') then
                counter_pixel_sig   <= 0;
            else
                if(counter_pixel_sig = H_PERIOD_cste-1) then
                    counter_pixel_sig   <= 0;
                    
                    if(counter_line_sig = V_PERIOD_cste-1)then
                        counter_line_sig   <= 0;
                    else
                        counter_line_sig   <= counter_line_sig + 1;
                    end if;
                    
                else
                    counter_pixel_sig   <= counter_pixel_sig + 1;
                end if;
            end if;
        end if;
    end process;

	-- User logic ends

end arch_imp;
