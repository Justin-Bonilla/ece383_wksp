----------------------------------------------------------------------------------
-- While the monitored_signal crosses the threshold, trigger is set
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trigger_detector is
    port (
        clk              : in  std_logic;
        reset_n          : in  std_logic;
        threshold        : in  unsigned;
        ready            : in  std_logic;
        monitored_signal : in  unsigned;
        crossed_trigger  : out std_logic
    );
end entity trigger_detector;

architecture trigger_detector_arch of trigger_detector is
    signal previous : unsigned(15 downto 7);
    signal G: std_logic;
    signal L: std_logic;
begin

    -- Register to hold previous value
    process (clk)
    begin
        if rising_edge(clk) then
        
            if reset_n = '0' then
               previous <= (others => '0');
            else
                if(ready = '1') then
                    previous <= monitored_signal;
                    end if;
            end if;
        end if;
    end process;

    G <= '1' when (monitored_signal > threshold) else
         '0';
   L <= '1' when previous < threshold else
        '0';
    crossed_trigger <= '1' when (G = '1') and (L = '1') else
                       '0';

end architecture trigger_detector_arch;
