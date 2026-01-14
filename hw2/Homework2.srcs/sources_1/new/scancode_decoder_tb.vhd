----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2026 11:16:17 PM
-- Design Name: 
-- Module Name: scancode_decoder_tb - Behavioral
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

entity scancode_decoder_tb is
--  Port ( );
end scancode_decoder_tb;

architecture Behavioral of scancode_decoder_tb is
component scancode_decoder
        Port (
            scancode      : in  STD_LOGIC_VECTOR (7 downto 0);
            decoded_value : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal s1 : std_logic_vector(7 downto 0);
    signal s2 : std_logic_vector(3 downto 0);

    constant test_elements : integer := 10;
    subtype input is std_logic_vector(7 downto 0);

    type test_input_vector is array(1 to test_elements) of input;
    signal test_input : test_input_vector :=
        ("01000101", "00010110", "00011110", "00100110", "00100101", "00101110", "00110110", "00111101","00111110","01000110");

    type test_output_vector is array(1 to test_elements) of std_logic_vector(3 downto 0);
    signal expected_output : test_output_vector :=
        ("0000","0001","0010","0011","0100","0101","0110","0111","1000","1001");

begin

    uut : scancode_decoder
        port map (
            scancode => s1,
            decoded_value => s2
        );

    stim_proc : process
    begin
        for i in 1 to test_elements loop
            s1 <= test_input(i);
            wait for 10 ns;
            assert s2 = expected_output(i)
                report "Error at test " & integer'image(i)
                severity failure;
        end loop;
        wait;
    end process;

end Behavioral;