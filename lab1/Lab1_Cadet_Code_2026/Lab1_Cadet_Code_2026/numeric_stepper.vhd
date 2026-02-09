-- Numeric Stepper: Holds a value and increments or decrements it based on button presses
-- James Trimble, 20 Jan 2026

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity numeric_stepper is
  generic (
    num_bits  : integer := 8;
    max_value : integer := 256;
    min_value : integer := 0;
    delta     : integer := 10
  );
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;                    -- active-low synchronous reset
    en      : in  std_logic;                    -- enable
    up      : in  std_logic;                    -- increment on rising edge
    down    : in  std_logic;                    -- decrement on rising edge
    q       : out signed(num_bits-1 downto 0)   -- signed output
  );
end numeric_stepper;

architecture numeric_stepper_arch of numeric_stepper is
    signal process_q : signed(num_bits-1 downto 0) := to_signed(0,num_bits);
    signal prev_up, prev_down : std_logic := '0';
    signal is_increment, is_decrement : boolean := false;
begin

process(clk)
begin
    if rising_edge(clk) then

       -- Reset all the signals when reset 
        if reset_n = '0' then
            process_q    <= (others => '0');
            prev_up      <= '0';
            prev_down    <= '0';
            is_increment <= FALSE;
            is_decrement <= FALSE;

        else
            -- Keep processq what it is and reset increment/decrement
            process_q <= process_q;
            is_increment  <= FALSE;
            is_decrement  <= FALSE;

            if en = '1' then

                -- button pressed up and not previously up then move trigger
                if (up = '1' and prev_up = '0') then
                    process_q <= process_q + delta;
                    is_increment <= TRUE;
                

                -- button pressed down and not previously down then move trigger
                elsif (down = '1' and prev_down = '0') then
                    process_q <= process_q - delta;
                    is_decrement <= TRUE;
                    end if;
                end if;

            -- set the previous signals to not double count
            prev_up   <= up;
            prev_down <= down;
    
   end if;       
   end if;
end process;
    
q <= process_q;


end numeric_stepper_arch;
