library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_register is
	port (
		clk : in std_logic;
		rst : in std_logic;
		input : in std_logic_vector(31 downto 0);
		IRWrite : in std_logic;
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
	process(clk,rst)
	begin
		if (rst = '1') then
			IR_31_26 <= (others => '0');
			IR_25_0 <= (others => '0');
			IR_25_21 <= (others => '0');
			IR_20_16 <= (others => '0');
			IR_15_11 <= (others => '0');
			IR_15_0 <= (others => '0');
		elsif (rising_edge(clk)) then
			if (IRWrite = '1') then
				IR_31_26 <= input(31 downto 26);
				IR_25_0 <= input(25 downto 0);
				IR_25_21 <= input(25 downto 21);
				IR_20_16 <= input(20 downto 16);
				IR_15_11 <= input(15 downto 11);
				IR_15_0 <= input(15 downto 0);
			end if;
		end if;
	end process;
end bhv;