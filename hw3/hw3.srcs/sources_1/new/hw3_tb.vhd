----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/15/2026 11:01:27 PM
-- Design Name: 
-- Module Name: hw3_tb - Behavioral
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

entity hw3_tb is
end hw3_tb;

architecture Behavioral of hw3_tb is
component hw3
        Port (
            d      : in  STD_LOGIC_VECTOR (7 downto 0);
            h : out std_logic
        );
    end component;
    
    signal s1 : std_logic_vector(7 downto 0);
    signal s2 : std_logic;
begin

 uut : hw3
        port map (
            d => s1,
            h => s2
        );
stim_proc : process
    begin
        s1 <= x"00";  -- 0000 = 0000 → equal
        wait for 1 ns;

        s1 <= x"11";  -- 0001 = 0001 → equal
        wait for 1 ns;

        s1 <= x"12";  -- 0001 ≠ 0010 → not equal
        wait for 1 ns;

        s1 <= x"FF";  -- 1111 = 1111 → equal
        wait for 1 ns;

        s1 <= x"A5";  -- 1010 ≠ 0101 → not equal
        wait;

    end process;

end Behavioral;

    end process;

end Behavioral;
