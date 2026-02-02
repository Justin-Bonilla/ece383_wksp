----------------------------------------------------------------------------------
-- Company: USAFA
-- Engineer: Justin Bonilla
-- 
-- Create Date: 01/21/2026 09:28:00 PM
-- Design Name: hw4_tb
-- Module Name: hw4_tb - Behavioral
-- Project Name: counter
-- Target Devices: ?
-- Tool Versions: ?
-- Description: Test bench for cascaded mod 10 counters
-- 
-- Dependencies: ?
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

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

entity hw4_tb is
end hw4_tb;

architecture Behavioral of hw4_tb is

    component counter
        generic (
            num_bits  : integer := 4;
            max_value : integer := 9
        );
        port (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            ctrl    : in  std_logic;
            roll    : out std_logic;
            Q       : out unsigned(num_bits-1 downto 0)
        );
    end component;

    -- Clock / control signals
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '0';
    signal ctrl    : std_logic := '0';

    -- Counter A signals
    signal roll_A  : std_logic;
    signal Q_A     : unsigned(3 downto 0);

    -- Counter B signals
    signal roll_B  : std_logic;
    signal Q_B     : unsigned(3 downto 0);

    -- Cascaded control
    signal ctrl_B  : std_logic;

begin

    -- Clock generation: 10 ns period
    clk <= not clk after 5 ns;

    -- Cascade enable (must be a signal)
    ctrl_B <= ctrl and roll_A;

    -- Counter A (ones digit)
    U_COUNTER_A : counter
        port map (
            clk     => clk,
            reset_n => reset_n,
            ctrl    => ctrl,
            roll    => roll_A,
            Q       => Q_A
        );

    -- Counter B (tens digit)
    U_COUNTER_B : counter
        port map (
            clk     => clk,
            reset_n => reset_n,
            ctrl    => ctrl_B,
            roll    => roll_B,
            Q       => Q_B
        );

    -- Stimulus process
    stim_proc : process
begin
    reset_n <= '0';
    ctrl    <= '0';
    wait for 20 ns;

    reset_n <= '1';   -- release reset

    ctrl <= '0';
    wait for 15 us;

    ctrl <= '1';
    wait until Q_A = 4;

    ctrl <= '0';
    wait until rising_edge(clk);
   

    ctrl <= '1';

    wait for 50 us;
    wait;
end process;

end Behavioral;
