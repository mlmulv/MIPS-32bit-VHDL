library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_register is
	port (
		input : in std_logic_vector(31 downto 0);
		IR_31_26 : out std_logic_vector (5 downto 0);
		IR_25_0 : out std_logic_vector (25 downto 0);
		IR_25_21 : out std_logic_vector (25 downto 21);
		IR_20_16 : out std_logic_vector (20 downto 16);
		IR_15_11 : out std_logic_vector (15 downto 11);
		IR_15_0 : out std_logic_vector (15 downto 0)
	);
end instruction_register;

architecture bhv of instruction_register is 


begin

	
end bhv;