library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_mips_tb is
end memory_mips_tb;

architecture tb of memory_mips_tb is

constant WIDTH : positive := 32; 
signal clk : std_logic := '0';
signal rst,inPort0_en,inPort1_en,memwrite : std_logic;
signal mem_address, inPort, input, outPort, output : std_logic_vector(WIDTH-1 downto 0);

begin
	UUT : entity work.memory_mips
		generic map (WIDTH => WIDTH)
		port map (
			clk => clk,
			rst => rst,
			inPort0_en => inPort0_en,
			inPort1_en => inPort1_en,
			memwrite => memwrite,
			mem_address => mem_address,
			inPort => inPort,
			input => input,
			outPort => outPort,
			output => output);
			
		clk <= not clk after 10 ns;
	process
	begin
		
		rst <= '1';
		inPort0_en <= '0';
		inPort1_en <= '0';
		inPort <= x"00000000";
		memwrite <= '0';
		mem_address <= x"00000000";
		input <= x"0A0A0A0A";
		wait for 20 ns;
		
		-- write 0A0A0A0A
		rst <= '0';
		memwrite <= '1';
		wait for 20 ns;
		
		memwrite <= '0';
		wait for 20 ns;
		 
		
		-- write F0F0F0F0
		memwrite <= '1';
		mem_address <= x"00000004";
		input <= x"F0F0F0F0";
		wait for 20 ns;
	
		memwrite <= '0';
		wait for 20 ns;
		
		-- read from address 0x00000000
		mem_address <= x"00000000";
		wait for 20 ns;
		
				
		-- read from address 0x00000001
		mem_address <= x"00000001";
		wait for 20 ns;
		
		
		-- read from address 0x00000004
		mem_address <= x"00000004";
		wait for 20 ns;
		
		-- read from address 0x00000005
		mem_address <= x"00000005";
		wait for 20 ns;
		
		
		-- write 0x00001111 to outport
		input <= x"00001111";
		mem_address <= x"0000FFFC";
		memwrite <= '1';
		wait for 20 ns;
		
		memwrite <= '0';
		wait for 20 ns;
		
		--Load 0x00010000 into inport 0
		memwrite <= '1';
		inPort0_en <= '1';
		inPort1_en <= '0';
		inPort <= x"00010000";
		wait for 20 ns;
		
		memwrite <= '0';
		inPort0_en <= '0';
		wait for 20 ns;
		
		-- Load 00000001 into inport 1
		memwrite <= '0';
		inPort1_en <= '1';
		inPort <= x"00000001";
		wait for 20 ns;
	
		inPort1_en <= '0';
		wait for 20 ns;
		
		-- Reading from inPort0
		mem_address <= x"0000FFFC";
		wait for 20 ns;
		
		-- Reading from inPort1
		mem_address <= x"0000FFF8";
		wait for 20 ns;
		
		wait;
	end process;
end tb;