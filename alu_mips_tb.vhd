library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mips_tb is
end alu_mips_tb;

architecture tb of alu_mips_tb is

constant WIDTH : positive := 32; 
signal alu_input1 : std_logic_vector (WIDTH -1 downto 0);
signal alu_input2 : std_logic_vector (WIDTH -1 downto 0);
signal op : std_logic_vector (5 downto 0);
signal shift : std_logic_vector (4 downto 0);
signal result,result_hi : std_logic_vector (WIDTH -1 downto 0);
signal branch_taken : std_logic;

begin

	UUT : entity work.alu_mips
        generic map (WIDTH => WIDTH)
        port map (
            alu_input1   => alu_input1,
            alu_input2   => alu_input2,
            op      => op,
            shift   => shift,
			result  => result,
			result_hi => result_hi,
            branch_taken => branch_taken);

	process
	begin
	
		-- 10 + 15
		alu_input1 <= std_logic_vector(to_unsigned(10, WIDTH));
        alu_input2 <= std_logic_vector(to_unsigned(15, WIDTH));
		op <= "010000";
		shift <= (others => '0');
        wait for 50 ns;
		
		-- 25-10
		alu_input1 <= std_logic_vector(to_unsigned(25, WIDTH));
        alu_input2 <= std_logic_vector(to_unsigned(10, WIDTH));
		op <= "010001";
		shift <= (others => '0');
		wait for 50 ns;
		
		-- 10 * -4 signed
		alu_input1 <= std_logic_vector(to_signed(10, WIDTH));
        alu_input2 <= std_logic_vector(to_signed(-4, WIDTH));
		op <= "010010";
		shift <= (others => '0');
		wait for 50 ns;
		
		-- 65536 * 131072 unsigned
		alu_input1 <= std_logic_vector(to_unsigned(65536, WIDTH));
        alu_input2 <= std_logic_vector(to_unsigned(131072, WIDTH));
		op <= "010011";
		shift <= (others => '0');
		wait for 50 ns;
		
		-- and 0x0000FFFF and 0xFFFF1234
		alu_input1 <= "00000000000000001111111111111111";
        alu_input2 <= "11111111111111110001001000110100";
		op <= "010100";
		shift <= (others => '0');
		wait for 50 ns;
		
		-- shift right logical of 0x0000000F by 4
		alu_input1 <= "00000000000000000000000000001111";
        alu_input2 <= (others => '0');
		op <= "010101";
		shift <= std_logic_vector(to_unsigned(4, shift'length));
		wait for 50 ns;
		
		-- shift right arithmetic of 0xF0000008 by 1
		alu_input1 <= "11110000000000000000000000001000";
        alu_input2 <= (others => '0');
		op <= "010110";
		shift <= std_logic_vector(to_unsigned(1, shift'length));
		wait for 50 ns;
		
		-- shift right arithmetic of 0x00000008 by 1
		alu_input1 <= "00000000000000000000000000001000";
        alu_input2 <= (others => '0');
		op <= "010110";
		shift <= std_logic_vector(to_unsigned(1, shift'length));
		wait for 50 ns;
		
		-- set on less than using 10 and 15
		alu_input1 <= std_logic_vector(to_unsigned(10, WIDTH));
        alu_input2 <= std_logic_vector(to_unsigned(15, WIDTH));
		op <= "010111";
		shift <= (others => '0');
		wait for 50 ns;
		
		-- set on less than using 15 and 10
		alu_input1 <= std_logic_vector(to_unsigned(15, WIDTH));
        alu_input2 <= std_logic_vector(to_unsigned(10, WIDTH));
		op <= "010111";
		shift <= (others => '0');
		wait for 50 ns;
		
        
		
        wait;
	
	end process;
end tb;