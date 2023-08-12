library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_mips is 
	generic (
		WIDTH : positive := 32
		);
	port (
		alu_input1 : in std_logic_vector (WIDTH -1 downto 0);
		alu_input2 : in std_logic_vector (WIDTH -1 downto 0);
		op : in std_logic_vector (5 downto 0);
		shift : in std_logic_vector (4 downto 0);
		result : out std_logic_vector (WIDTH -1 downto 0);
		result_hi : out std_logic_vector (WIDTH -1 downto 0);
		branch_taken : out std_logic);
end alu_mips;
		
architecture bhv of alu_mips is
	signal zeros : std_logic_vector(WIDTH -2 downto 0);
	signal one : std_logic_vector(WIDTH -1 downto 0);
begin	

	process(op,shift,alu_input1,alu_input2)
	variable temp_mult_sg : signed(WIDTH*2 - 1 downto 0);
	variable temp_mult_un : unsigned(WIDTH*2 - 1 downto 0);
	begin
	
	branch_taken <= '0';
	result <= alu_input1;
	result_hi <= (others => '0');
	zeros <= (others => '0');
	one <= zeros & '1';
	
	-- I type
		if (op = "000001") then
			if (unsigned(alu_input1) < 0) then
				branch_taken <= '1'; -- for greater than or equal to you have to not the output
			end if;
		
		elsif (op = "000100") then
			if (unsigned(alu_input1) = unsigned(alu_input2)) then
				branch_taken <= '1';
			end if;
			
		elsif (op = "000101") then
			if (unsigned(alu_input1) /= unsigned(alu_input2)) then
				branch_taken <= '1';
			end if;
			
		elsif (op = "000110") then
			if (unsigned(alu_input1) <=  0) then 
				branch_taken <= '1';
			end if;
			
		elsif (op = "000111") then
			if (unsigned(alu_input1) > 0) then
				branch_taken <= '1';
			end if;
			
		-- NOT COMPLETE WITH REST OF I TYPE
			
		-- R type
		-- add unsigned
		elsif (op = "010000") then
			result <= std_logic_vector(unsigned(alu_input1) + unsigned(alu_input2));
		
		--sub unsigned
		elsif (op = "010001") then
			result <= std_logic_vector(unsigned(alu_input1) - unsigned(alu_input2));
		
		-- mult signed
		elsif (op = "010010") then
			temp_mult_sg := signed(alu_input1) * signed(alu_input2);
			result <= std_logic_vector(temp_mult_sg(WIDTH -1 downto 0));
			result_hi <= std_logic_vector(temp_mult_sg(2 *WIDTH -1 downto WIDTH));
			
		-- mult unsigned
		elsif (op = "010011") then
			temp_mult_un := unsigned(alu_input1) * unsigned(alu_input2);
			result <= std_logic_vector(temp_mult_un(WIDTH -1 downto 0));
			result_hi <= std_logic_vector(temp_mult_un(WIDTH*2 -1 downto WIDTH));
						
		-- and 
		elsif (op = "010100") then
			result <= alu_input1 and alu_input2;
		
		-- shift right logical
		elsif (op = "010101") then
			result <= std_logic_vector(shift_right(unsigned(alu_input1), to_integer(unsigned(shift))));
		
		-- shift right arthimetic
		elsif (op = "010110") then
			result <= std_logic_vector(rotate_right(unsigned(alu_input1), to_integer(unsigned(shift))));
			
		
		-- set on less than
		elsif (op = "010111") then
			if (alu_input1 < alu_input2) then
				result <= one;
			else 
				result <= (others => '0');
			end if;
		end if;
		
		-- NOT COMPLETE WITH REST OF R TYPE
	end process;
end bhv;
		
	
		
	
			
		