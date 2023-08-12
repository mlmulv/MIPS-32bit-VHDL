library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_controller is
	port (
		IR_31_26 : in std_logic_vector(5 downto 0);
		PCWriteCond : out std_logic;
		PCWrite : out std_logic;
		IorD : out std_logic;
		MemRead : out std_logic;
		MemWrite : out std_logic;
		MemtoReg : out std_logic;
		IRWrite : out std_logic;
		JumpandLink : out std_logic;
		IsSigned : out std_logic;
		PCSource : out std_logic_vector(1 downto 0);
		ALUOp : out std_logic_vector(3 downto 0);
		ALUSrcB : out std_logic_vector(1 downto 0);
		ALUScrA : out std_logic;
		RegWrite :out std_logic;
		RegDst : out std_logic
	);
end mips_controller;

architecture bhv of mips_controller is 


begin

	
end bhv;