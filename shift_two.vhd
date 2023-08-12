library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_two is
	generic (
	IN_WIDTH : positive := 26);
	port (
		input : std_logic_vector(IN_WIDTH-1 downto 0);
		output : std_logic_vector(IN_WIDTH+1 downto 0)
	);
end shift_two;

architecture bhv of shift_two is 


begin

	
end bhv;