library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_extend is
	port (
		IsSigned : in std_logic;
		input : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(31 downto 0)
	);
end sign_extend;

architecture bhv of sign_extend is 
signal ones : std_logic_vector(15 downto 0) := "1111111111111111";
signal zeros : std_logic_vector(15 downto 0) := "0000000000000000";

begin
	process(input,IsSigned,ones,zeros)
	begin
	
	output <= (others => '0');
		if(IsSigned = '1') then
			output <= ones & input;
		elsif(IsSigned = '0') then
			output <= zeros & input;
		end if;
	end process;
end bhv;