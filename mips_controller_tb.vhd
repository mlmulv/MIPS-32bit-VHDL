library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_controller_tb is
end mips_controller_tb;

architecture TB of mips_controller_tb is
signal rst, inPort0_en, inPort1_en : std_logic;
signal clk : std_logic := '0';
signal switches : std_logic_vector(9 downto 0);
signal outPort : std_logic_vector(31 downto 0);

begin

	UUT : entity work.mips_datapath port map(
		clk => clk,
		rst => rst,
		switches => switches,
		inPort0_en => inPort0_en,
	    inPort1_en => inPort1_en,
		outPort => outPort );

	clk <= not clk after 10 ns;
	
	process
	begin
	
	rst <= '1';
	inPort0_en <= '1';
	inPort1_en <= '0';
	switches <= "0111111111";
	wait for 20 ns;
	
	rst <= '0';
	wait for 20 ns;
	
	
	wait;
	
	end process;
end TB;