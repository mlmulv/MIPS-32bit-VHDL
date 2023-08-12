library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
	port (
		IR_5_0 : in std_logic_vector(5 downto 0);
		OPSelect : out std_logic_vector(5 downto 0);
		ALU_LO_HI : out std_logic_vector(1 downto 0);
		ALUOp : out std_logic_vector(3 downto 0)
	);
end alu_control;

architecture bhv of alu_control is 


begin

	
end bhv;