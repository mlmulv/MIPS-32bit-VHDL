library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_3x2 is
	generic (
		WIDTH : positive := 32);
	port (
		input1,input2, input3 : in std_logic_vector(WIDTH -1 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		sel : in std_logic_vector(1 downto 0));
end mux_3x2;

architecture bhv of mux_3x2 is

begin

	process(input1, input2, input3, sel)
	begin
	
		if (sel = "00") then
			output <= input3;
		elsif (sel = "01") then
			output <= input2;
		elsif (sel = "10") then
			output <= input1;
		end if;
	end process;
end bhv;