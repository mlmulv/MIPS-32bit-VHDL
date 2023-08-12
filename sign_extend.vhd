library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	port (
		IsSigned : in std_logic;
		input : std_logic_vector(15 downto 0);
		output : std_logic_vector(31 downto 0)
	);
end sign_extend;

architecture bhv of sign_extend is 


begin

	
end bhv;