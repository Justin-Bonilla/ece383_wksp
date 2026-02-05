-- vga_signal_generator Generates the hsync, vsync, blank, and row, col for the VGA signal

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity vga_signal_generator is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           position: out coordinate_t;
           vga : out vga_t);
end vga_signal_generator;

architecture vga_signal_generator_arch of vga_signal_generator is

    signal horizontal_roll, vertical_roll: std_logic := '0';		
    signal h_counter_ctrl, v_counter_ctrl: std_logic := '1'; -- Default to counting up
    signal h_sync_is_low, v_sync_is_low, h_blank_is_low, v_blank_is_low : boolean := false;
    signal current_pos : coordinate_t;


begin

-- horizontal counter
col_counter : counter
generic map(
      num_bits  => 10,
      max_value => 799
    )
    port map( clk => clk,
           reset_n => reset_n,
           ctrl => h_counter_ctrl,
           roll => horizontal_roll,
           Q => current_pos.col
           );


-- Glue code to connect the horizontal and vertical counters
v_counter_ctrl <= horizontal_roll;


-- vertical counter
row_counter : counter
generic map(
      num_bits  => 10,
      max_value => 524
    )
    port map( clk => clk,
           reset_n => reset_n,
           ctrl => v_counter_ctrl,
           roll => vertical_roll,
           Q => current_pos.row
           );

-- END OF THE COUNTERS 

position <= current_pos;

--H BLANK WORKS GOOD
h_blank_is_low <= TRUE when current_pos.col >= 639 and current_pos.col < 799 else
                  FALSE;
--V BLANK WORKS GOOD
v_blank_is_low <= TRUE when (current_pos.row = 479 and current_pos.col = 799) 
                         or (current_pos.row > 479 and current_pos.row < 524) or (current_pos.row = 524 and current_pos.col <799) -- !!!!!! original is 524
                   else FALSE;

--Horizontal sync comparison, GOOD
--       if (current_pos.col >= 655) and (current_pos.col < 751) then
--            h_sync_is_low <= TRUE;
--        end if;
h_sync_is_low <= TRUE when (current_pos.col >= 656) and (current_pos.col < 752) else
                 FALSE;

--Vertical sync comparison, BAD
--        if (current_pos.row >= 489) and (current_pos.row < 492) then
--            v_sync_is_low <= TRUE;
--        end if;
v_sync_is_low <= TRUE when (current_pos.row > 489 and current_pos.row < 492) or (current_pos.row = 490 and current_pos.col = 799) else
                 FALSE;


process(clk)
    begin
    if rising_edge(clk) then

        
        --h_sync_is_low  <= FALSE;
        --v_sync_is_low  <= FALSE;
        --h_blank_is_low <= FALSE;
        --v_blank_is_low <= FALSE;

        -- Horizontal sync comparison, GOOD
--        if (current_pos.col >= 655) and (current_pos.col < 751) then
--            h_sync_is_low <= TRUE;
--        end if;
        
--        -- Vertical sync comparison, BAD
--        if (current_pos.row >= 489) and (current_pos.row < 492) then
--            v_sync_is_low <= TRUE;
--        end if;

        if (h_blank_is_low = TRUE or v_blank_is_low = TRUE) then
            vga.blank <= '1';
        else
            vga.blank <= '0';
        end if;
        
--        if (h_sync_is_low = TRUE) then
--            vga.hsync <= '1';
--        else
--            vga.blank <= '0';
--        end if;
        
--        if (v_sync_is_low = TRUE) then
--            vga.vsync <= '1';
--        else
--            vga.blank <= '0';
--        end if;
        
        
            
       
    end if;
end process;


vga.hsync <= '0' when h_sync_is_low else '1';
vga.vsync <= '0' when v_sync_is_low else '1';


end architecture vga_signal_generator_arch;