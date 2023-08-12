library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity address_decoder_mips is
	generic (
		WIDTH : positive := 32);
	port (
		address : in std_logic_vector(WIDTH-1 downto 0);
		memwrite : in std_logic;
		ram_write_en : out std_logic;
		outPort_en : out std_logic;
		out_sel : out  std_logic_vector(1 downto 0)
		);
end address_decoder_mips;

architecture bhv of address_decoder_mips is
signal ram_address : std_logic_vector (7 downto 0);
begin

	process(address,memwrite)
	begin
		outPort_en <= '0';
		ram_write_en <= '0';
	
		ram_address <= address(9 downto 2);
		if (memwrite = '1') then
			if (unsigned(ram_address) < 256 and not(address = x"0000FFFC")) then
				ram_write_en <= '1';
			end if;
			if (address = x"0000FFFC") then
				outPort_en <= '1';
			end if;
		elsif (memwrite = '0') then 
			if (unsigned(ram_address) < 256 and not(address = x"0000FFFC")) then
				out_sel <= "00";
				ram_write_en <= '0';
			end if;
			if (address = x"0000FFFC") then
				out_sel <= "01";
			elsif (address = x"0000FFF8") then
				out_sel <= "10";
			end if;
		end if;
	end process;
end bhv;