library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_mux1 is 
	generic (WIDTH : positive := 16);
	port (
		input1,input2 : in std_logic_vector(WIDTH-1 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		sel : in std_logic);
end generic_mux1;

architecture bvh of generic_mux1 is
begin	
	
	process(sel,input1,input2)
	begin
			
		if (sel = '1') then
			output <= input2;
		else
			output <= input1;
		end if;
	end process;
end bvh;