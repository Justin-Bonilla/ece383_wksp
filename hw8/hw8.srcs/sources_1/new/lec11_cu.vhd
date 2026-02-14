----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2026 07:53:33 PM
-- Design Name: 
-- Module Name: lec11_cu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;		
use IEEE.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;



entity lec11_cu is
	Port(	clk: in  STD_LOGIC;
			reset : in  STD_LOGIC;
			kbClk: in std_logic;
			cw: out STD_LOGIC_VECTOR(3 downto 0);
			sw: in STD_LOGIC;
			busy: out std_logic);
end lec11_cu;

architecture behavior of lec11_cu is
	
	type state_type is (
	busy_0,
	comp_0,
	busy_1,
	for_loop0,
	comp_1,
	shift,
	comp_2,
	scan
	);
	signal state: state_type;
	


	-- these values are for 100KHz
--    signal D : unsigned(10 downto 0) := (others => '0');
--    signal Q : unsigned(10 downto 0);
        
begin
    
   -----------------------------------------------------------------------
   --    CONTROL UNIT
   -----------------------------------------------------------------------
   state_process: process(clk)
	 begin
		if (rising_edge(clk)) then
			if (reset = '1') then 
				state <= busy_0;
			else
				case state is
					when busy_0 => 
						state <= comp_0;
					when comp_0 => 
						if (kbClk = '0') then state <= busy_1;
						else state<= comp_0; 
						end if;
					when busy_1 =>
					   	 state <= for_loop0;
					when for_loop0 =>
					   	if (sw = '1') then state <= comp_1;
					   	else state <= scan ;
					   	 end if;
					when comp_1 =>
					   	if(kbClk = '0') then state <= shift;
					   	else state <= comp_1;
					   	 end if;
					when shift =>
					   	state <= comp_2;
					when comp_2 =>
					   	if(kbClk = '1') then state <= for_loop0;
					   	else state <= comp_2;
					   	 end if;
					when scan =>
					      state <= busy_0;
					
				end case;
			end if;
		end if;
	end process;


	------------------------------------------------------------------------------
	--			OUTPUT EQUATIONS
	--	
	--		cw is counter control:  00 is hold; 01 is increment; 11 is reset	
	------------------------------------------------------------------------------	
	cw <=   "0000" when state = busy_0 else
			"0000" when state = comp_0 else
			"0011" when state = busy_1 else
			"0001" when state = for_loop0 else
			"1000" when state = scan else
			"0000" when state = comp_1 else
			"0100" when state = shift else
			"0000" when state = comp_2 ;
			
				
	busy <= '1' when state = busy_1 else '0';
	
end behavior;
