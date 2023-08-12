library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity andtwo is
	port (
		input1: in std_logic;
		input2 : in std_logic;
		output : out std_logic
	);
end andtwo;

architecture bhv of andtwo is 
begin

	process(input1,input2)
	begin
		output <= input1 and input2;
	end process;
end bhv;