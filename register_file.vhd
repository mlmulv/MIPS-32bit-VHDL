library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
	port (
		
		IR_25_21 : in std_logic_vector (25 downto 21);
		IR_20_16 : in std_logic_vector (20 downto 16);
		WriteReg : in std_logic_vector (4 downto 0);
		WriteData : in std_logic_vector (31 downto 0);
		IsSigned : in std_logic;
		JumpAndLink : in std_logic;
		Data1 : out std_logic_vector (31 downto 0);
		Data2 : out std_logic_vector (31 downto 0)
	);
end register_file;

architecture bhv of register_file is 


begin

	
end bhv;