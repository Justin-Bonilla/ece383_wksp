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
	wait_for_trigger,
	wait_for_ready,
	save_sample
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
				state <= wait_for_trigger;
			else 
				case state is  
				
					when wait_for_trigger =>
					   if (sw(2) = '1') then state <= wait_for_ready;
					   else state<= wait_for_trigger; 
					   end if;
					when wait_for_ready => -- 
					   if (sw(0) = '1') then state <= save_sample;
					   else state <= wait_for_ready;
					   end if;
					when save_sample => -- for loop body
					   if (sw(1) = '1') then state <= wait_for_trigger; -- last value?
					   else state<= wait_for_ready;  
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
	
	cw <=   "000" when state = wait_for_trigger else
			"010" when state = wait_for_ready else
			"111" when state = save_sample;
			
    
			

end Behavioral;

