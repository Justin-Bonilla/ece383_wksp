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
	--		
	-------------------------------------------------------------------------------
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then 
				state <= trig_detect;
			else 
				case state is 
					when trig_detect =>
					   if (sw(2) = '1') then state <= trig_detect;
					   else state<= write_def; 
					   end if;
					when write_def =>
					   state <= write_lt;
					when write_lt =>
					   if (sw(1) = '1') then state <= ready0;
					   else state<= write_lt; 
					   end if;
				    when ready0 =>
					   if (sw(0) = '0') then state <= ready0;
					   else state<= write1; 
					   end if;
					when write1 =>
					   state <= write0;
					when write0 =>
					   state<= ready1; 
					when ready1 =>
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
	--		
	-------------------------------------------------------------------------------
	
	cw <=   "000" when state = trig_detect else
			"000" when state = write_def else
			"001" when state = write_lt else
			"000" when state = ready0 else
			"100" when state = write1 else
			"000" when state = write0 else
			"010" when state = ready1;
			

end Behavioral;

