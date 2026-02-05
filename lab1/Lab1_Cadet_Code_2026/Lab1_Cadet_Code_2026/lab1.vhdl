----------------------------------------------------------------------------------
--	Title
--  Name
--  Description
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity lab1 is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(4 downto 0);
		   led: out STD_LOGIC_VECTOR(4 downto 0);
		   sw: in STD_LOGIC_VECTOR(1 downto 0);
           tmds : out  STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out  STD_LOGIC_VECTOR (3 downto 0));
end lab1;

architecture structure of lab1 is

    constant CENTER : integer := 0;
    constant DOWN : integer := 1;
    constant LEFT : integer := 2;
    constant RIGHT : integer := 3;
    constant UP : integer := 4;

    signal trigger: trigger_t;
	signal pixel: pixel_t;
	signal ch1, ch2: channel_t;
	signal time_trigger_value, volt_trigger_value : signed(10 downto 0);
	--signal time_trigger_value, volt_trigger_value : unsigned(10 downto 0);
	signal position: coordinate_t;

begin
   
-- Add numeric steppers for time and voltage trigger
timeStep : numeric_stepper
generic map(
      num_bits  => 11,
      max_value => 640,
      min_value => 0,
      delta => 10
    )
    port map( clk => clk,
           reset_n => reset_n,
           en => sw(0),
           up => btn(RIGHT),
           down => btn(LEFT),
           q => time_trigger_value
           );

voltStep : numeric_stepper
generic map(
      num_bits  => 11,
      max_value => 480,
      min_value => 0,
      delta => 10    
      )
    port map( clk => clk,
           reset_n => reset_n,
           en => sw(1),
           up => btn(UP),
           down => btn(DOWN),
           q => volt_trigger_value
           );



-- Assign trigger.t and trigger.v
  trigger.t <= unsigned(time_trigger_value) ;
  trigger.v <= unsigned(volt_trigger_value) ;
       	
-- Instantiate video

 video_inst :  video
port map (
  clk      => clk,
  reset_n  => reset_n,
  tmds     => tmds,
  tmdsb    => tmdsb,
  trigger  => trigger,
  position => position,
  ch1      => ch1,
  ch2      => ch2
);
-- Determine if ch1 and or ch2 are active
ch1.active <= '1' when sw(0) = '1' and ch1.en = '1';
ch2.active <= '1' when sw(1) = '1' and ch2.en = '1';

-- Connect board hardware to signals
led <= (others => '1');

end structure;
