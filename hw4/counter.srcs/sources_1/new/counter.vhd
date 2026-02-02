----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: Justin Bonilla
-- 
-- Create Date: 01/21/2026 09:28:00 PM
-- Design Name:  counter
-- Module Name: counter - Behavioral
-- Project Name: counter
-- Target Devices: ?
-- Tool Versions: ?
-- Description: Counter that rolls over at 9 and updates second counter
-- 
-- Dependencies: ?
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    generic (
           num_bits : integer := 4;
           max_value : integer := 9
    );
    port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           ctrl : in STD_LOGIC;
           roll : out STD_LOGIC;
           Q : out unsigned (num_bits-1 downto 0));
end counter;

architecture behavior of counter is

--Update the signal before actually assigning the output of Q
signal processQ: unsigned (num_bits-1 downto 0);

begin


process(clk)
    begin
        if rising_edge(clk) then -- Rising edge of the clock controls when things happens, gated output
            if reset_n = '0' then --resets the counter to 0 and control to 1
                processQ <= (others => '0');
        
        
            elsif ctrl = '1' then --This is the mode for the processQ to count up 
                if processQ = max_value then --This is the mod to roll back over to 0 when at 9
                    processQ <= (others => '0');
                
                    
                else
                --If not at max(9) then continue to count up
                    processQ <= processQ + 1;
                end if;
         end if;
    end if;
end process;

-- Had to remember to take combinational logic out of clk or else it will process to late
roll <= '1' when (processQ = max_value and ctrl = '1') else '0';
Q <= processQ;


end behavior;



