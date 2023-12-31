library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ortwo is
	port (
		input1: in std_logic;
		input2 : in std_logic;
		output : out std_logic
	);
end ortwo;

architecture bhv of ortwo is 
begin

	process(input1,input2)
	begin
		output <= input1 or input2;
	end process;
end bhv;