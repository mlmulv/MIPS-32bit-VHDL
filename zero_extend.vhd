library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zero_extend is
	port (
		input : in std_logic_vector(8 downto 0);
		output : out std_logic_vector (31 downto 0)
	);
end zero_extend;

architecture bhv of zero_extend is 
signal ones : std_logic_vector(22 downto 0) := "00000000000000000000000";

begin
	process(input,ones)
	begin
		output <= ones & input;
	end process;
	
end bhv;