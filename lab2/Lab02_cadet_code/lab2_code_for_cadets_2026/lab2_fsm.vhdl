----------------------------------------------------------------------------------
-- Name:	Template by George York (modified from Jeff Falkinburg)
-- Date:	Spring 2023
-- File:    lab2_fsm.vhd
-- HW:	    Lab 2 
-- Pupr:	Lab 2 Finite State Machine for the write circuitry.  
--
-- Doc:	Adapted from Dr Coulston's Lab exercise
-- 	
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lab2_fsm is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (2 downto 0);
           cw : out  STD_LOGIC_VECTOR (2 downto 0));
end lab2_fsm;

architecture Behavioral of lab2_fsm is

	type state_type is (
	trig_detect,
	write_def,
	write_lt,
	ready0,
	write1,
	write0,
	ready1
	);
	signal state: state_type;
	
	
    
    
    
    
    
    
begin

    
	-------------------------------------------------------------------------------
	--		SW		meaning
	--		sw(0) <= sw_ready;
    --      sw(1) <= sw_last_address;
    --      sw(2) <= sw_trigger;
	-------------------------------------------------------------------------------
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then 
				state <= trig_detect;
			else 
				case state is  -- Need to add an if for trig detect
				-- this block only happens while the trigger is true
					when trig_detect =>
					   if (sw(2) = '0') then state <= trig_detect;
					   else state<= write_def; 
					   end if;
					when write_def => -- init for loop
					   state <= write_lt;
					when write_lt => -- for loop body
					   if (sw(1) = '0') then state <= ready0; -- last value?
					   else state<= trig_detect;  
					   end if;
				    when ready0 => -- wait for ready flag
					   if (sw(0) = '0') then state <= ready0;
					   else state<= write1; 
					   end if;
					when write1 => -- write enable
					   state <= write0;
					when write0 => -- write disable
					   state<= ready1; 
					when ready1 => -- wait for ready flag to be 0
					   if (sw(0) = '1') then state <= ready1;
					   else state<= write_lt; 
					   end if;
					   
				end case;
			end if;
		end if;
	end process;

	-------------------------------------------------------------------------------
	--  CW output table
	--		CW		meaning
	--		cw_counter_control <= cw(1 downto 0);
	--      cw(1) is reset_n for counter
    --      cw(0) is what tells the counter to count
    --      cw_write_en <= cw(2);
    --      
	-------------------------------------------------------------------------------
	
	cw <=   "000" when state = trig_detect else
			"000" when state = write_def else
			"011" when state = write_lt else
			"010" when state = ready0 else
			"110" when state = write1 else
			"010" when state = write0 else
			"000" when state = ready1;
    
			

end Behavioral;

