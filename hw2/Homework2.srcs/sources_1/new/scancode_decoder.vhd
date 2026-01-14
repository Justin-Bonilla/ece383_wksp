----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2026 11:16:17 PM
-- Design Name: 
-- Module Name: scancode_decoder - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity scancode_decoder is
    Port ( scancode : in STD_LOGIC_VECTOR (7 downto 0);
           decoded_value : out STD_LOGIC_VECTOR (3 downto 0));
end scancode_decoder;

architecture Behavioral of scancode_decoder is

begin
decoded_value <= "0000" when scancode = "01000101" else
"0001" when scancode = "00010110" else
"0010" when scancode = "00011110" else
"0011" when scancode = "00100110" else
"0100" when scancode = "00100101" else
"0101" when scancode = "00101110" else
"0110" when scancode = "00110110" else
"0111" when scancode = "00111101" else
"1000" when scancode = "00111110" else
"1001" when scancode = "01000110" ;
                  

end Behavioral;
