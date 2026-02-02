----------------------------------------------------------------------------------
-- Lt Col James Trimble, 16-Jan-2025
-- color_mapper (previously scope face) determines the pixel color value based on the row, column, triggers, and channel inputs 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity color_mapper is
    Port ( color : out color_t;
           position: in coordinate_t;
		   trigger : in trigger_t;
           ch1 : in channel_t;
           ch2 : in channel_t);
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal trigger_color : color_t := YELLOW; 
signal grid_color : color_t := WHITE; 
signal ch1_color : color_t := BLUE; 
signal ch2_color : color_t := GREEN; 
signal bg_color : color_t := BLACK;

-- Add other colors you want to use here

signal is_vertical_gridline, is_horizontal_gridline, is_within_grid, is_trigger_time, is_trigger_volt, is_ch1_line, is_ch2_line,
    is_horizontal_hash, is_vertical_hash : boolean := false;

-- Fill in values here
constant grid_start_row : integer := 20 ;
constant grid_stop_row : integer := 420;
constant grid_start_col : integer := 20;
constant grid_stop_col : integer := 620;
constant num_horizontal_gridblocks : integer := 10;
constant num_vertical_gridblocks : integer := 8;
constant center_column : integer := 320;
constant center_row : integer := 220;
constant hash_size : integer :=  5;
constant hash_horizontal_spacing : integer := 15;
constant hash_vertical_spacing : integer := 10;
constant vertical_grid_spacing   : integer := (grid_stop_row - grid_start_row) / num_vertical_gridblocks;
constant horizontal_grid_spacing : integer := (grid_stop_col - grid_start_col) / num_horizontal_gridblocks;

begin

-- Assign values to booleans here
is_horizontal_gridline <= TRUE when
    is_within_grid and
    ((position.row - grid_start_row) mod vertical_grid_spacing = 0)
else FALSE;

is_vertical_gridline <= TRUE when
    is_within_grid and
    ((position.col - grid_start_col) mod horizontal_grid_spacing = 0)
else FALSE;
is_within_grid <= TRUE when (position.col <= grid_stop_col and position.col >= grid_start_col) and (position.row <= grid_stop_row and position.row >= grid_start_row)
else FALSE;
is_trigger_time <= TRUE when
    is_within_grid and
    (position.row >= grid_start_row) and
    (position.row < grid_start_row + 5) and
    (
      abs(
        to_integer(position.col) -
        to_integer(trigger.t + grid_start_col)
      )
      <=
      4 - (4 - (position.row - grid_start_row))
    )
else FALSE;
is_trigger_volt <= TRUE when
    is_within_grid and
    (position.col >= grid_start_col) and
    (position.col < grid_start_col + 5) and
    (
      abs(
        to_integer(position.row) -
        to_integer(trigger.v + grid_start_row)
      )
      <=
      4 - (4 - (position.col - grid_start_col))
    )
else FALSE;
is_ch1_line <= TRUE when (ch1.en = '1' and ch1.active = '1')
else FALSE;
is_ch2_line <= TRUE when (ch2.en = '1' and ch2.active = '1')
else FALSE;
is_horizontal_hash <= TRUE when
    abs(to_integer(position.row) - center_row) <= 4 and
    (abs(to_integer(position.col) - center_column) mod hash_horizontal_spacing) = 0 and
    is_within_grid
else FALSE;
is_vertical_hash <= TRUE when
    abs(to_integer(position.col) - center_column) <= 8 and
    (abs(to_integer(position.row) - center_row) mod hash_vertical_spacing) = 0 and
    is_within_grid
else FALSE;
-- is_horizontal_hash <= TRUE when((position.col mod hash_horizontal_spacing) = 0) and position.row
-- For the horizontal and vertical hash I need to do an absolute value +- the space where the hash should be. Similar to volt_time



-- Use your booleans to choose the color

color <=        trigger_color when (is_trigger_time or is_trigger_volt) else
                grid_color when(is_vertical_gridline or is_horizontal_gridline) else
                grid_color when(is_vertical_hash or is_horizontal_hash) else
                ch1_color when (is_ch1_line) else
                ch2_color when (is_ch2_line) else
                bg_color;
                -- all of the colors should be here. Just need to fix the boolean for the hashes.              

end color_mapper_arch;
