----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- Create Date: 01/27/2026 11:06:57 PM
-- Design Name: 
-- Module Name: vga_counter_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity tb_vga_signal_generator is
end tb_vga_signal_generator;

architecture sim of tb_vga_signal_generator is

    -- DUT signals
    signal clk       : std_logic := '0';
    signal reset_n   : std_logic := '0';
    signal position  : coordinate_t;
    signal vga       : vga_t;

    constant CLK_PERIOD : time := 40 ns;  -- 25 MHz

begin

    --------------------------------------------------------------------
    -- DUT instantiation
    --------------------------------------------------------------------
    uut : entity work.vga_signal_generator
        port map (
            clk       => clk,
            reset_n   => reset_n,
            position  => position,
            vga       => vga
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    --------------------------------------------------------------------
    -- Reset + simulation control
    --------------------------------------------------------------------
    stim_proc : process
    begin
        -- Hold reset low initially
        reset_n <= '0';
        wait for 200 ns;

        -- Release reset
        reset_n <= '1';

        -- Run long enough to see:
        -- 800 clocks per line
        -- 525 lines per frame
        wait for CLK_PERIOD * 800 * 525;

        -- Stop simulation
        wait;
    end process;

end sim;