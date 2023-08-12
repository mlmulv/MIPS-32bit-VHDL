library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_left_no_add is
	port (
		input: in std_logic_vector(31 downto 0);
		output : out std_logic_vector(31 downto 0)
	);
end shift_left_no_add;

architecture bhv of shift_left_no_add is
signal zeros : std_logic_vector(1 downto 0) := "00";
 
begin
	process(input,zeros)
	variable temp : std_logic_vector(33 downto 0);
	begin
		temp := input & zeros;
		output <= temp(31 downto 0);
	end process;
end bhv;