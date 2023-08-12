library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory_mips is
	generic (
		WIDTH : positive := 32);
	port (
		clk : in std_logic;
		rst : in std_logic;
		mem_address : in std_logic_vector(WIDTH-1 downto 0);
		inPort : in std_logic_vector(WIDTH-1 downto 0);
		inPort0_en : in std_logic;
	    inPort1_en : in std_logic;
		input : in std_logic_vector(WIDTH-1 downto 0);
		outPort : out std_logic_vector(WIDTH-1 downto 0);
		memwrite : in std_logic;
		output : out std_logic_vector(WIDTH-1 downto 0));
end memory_mips;

architecture bhv of memory_mips is
signal inPort0_out, inPort1_out, out_RAM, input_data : std_logic_vector (WIDTH-1 downto 0);
signal ram_write_en, outPort_en : std_logic;
signal out_sel, sel : std_logic_vector(1 downto 0);
begin
	
	INPORT0_REG: entity work.reg_async_rst port map (
		input => inPort,
		output => inPort0_out,
		en => inPort0_en,
		clk => clk,
		rst => '0');
		
	INPORT1_REG: entity work.reg_async_rst port map (
		input => inPort,
		output => inPort1_out,
		en => inPort1_en,
		clk => clk,
		rst => '0');
		
	RAM: entity work.blank_ram port map (
		address => mem_address(9 downto 2),
		clock => clk,
		data => input,
		q => out_Ram,
		wren => ram_write_en);
		
	MEMORY_DECODER : entity work.address_decoder_mips generic map (
		WIDTH => WIDTH)
		port map (
		address => mem_address,
		memwrite => memwrite,
		ram_write_en => ram_write_en,
		outPort_en => outPort_en,
		out_sel => out_sel);
		
		
	REG_SEL : entity work.reg_async_rst generic map (
		WIDTH => 2)
		port map (
		input => out_sel,
		output => sel,
		clk => clk,
		rst => rst,
		en => '1');
		
	OUTPORT_reg: entity work.reg_async_rst port map (
		input => input,
		output => outPort,
		en => outPort_en,
		clk => clk,
		rst => rst);
		
	MUX : entity work.mux_3x2 generic map (
		WIDTH => WIDTH)
		port map (
			input3 => out_RAM,
			input2 => inPort0_out,
			input1 => inPort1_out,
			sel => sel,
			output => output);
end bhv;