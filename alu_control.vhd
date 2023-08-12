library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control is
	port (
		IR_5_0 : in std_logic_vector(5 downto 0);
		OPSelect : out std_logic_vector(5 downto 0);
		ALU_LO_HI : out std_logic_vector(1 downto 0);
		ALUOp : in std_logic_vector(5 downto 0);
		ADD : in std_logic;
		NO_OP : in std_logic
	);
end alu_control;

architecture bhv of alu_control is 
begin

	process(IR_5_0, ALUOp, ADD, NO_OP)
	begin
		OPSelect <= (others => '0');
		ALU_LO_HI <= "00";
		-- R type instructions
				
		-- rtype instruction multiplexing alu_out
		if (ALUOp = "111111") then
			ALU_LO_HI <= "00";
		end if;
		
		if (ALUOp = "000000") then
			--addu
			if (IR_5_0 = "100001") then
				OPSelect <= "010000";
			-- and
			elsif (IR_5_0 = "100100") then
				OPSelect <= "010100";
			-- or
			elsif (IR_5_0 = "100101") then
				OPSelect <= "011100";
			-- xor
			elsif (IR_5_0 = "100110") then
				OPSelect <= "011000";
			-- multu
			elsif (IR_5_0 = "011001") then
				OPSelect <= "010011";
			-- mult signed
			elsif (IR_5_0 = "011000") then
				OPSelect <= "010010";
			--mflo
			elsif (IR_5_0 = "010010") then
				ALU_LO_HI <= "01";
			-- mfhi
			elsif (IR_5_0 = "010000") then
				ALU_LO_HI <= "10";
			--sub
			elsif (IR_5_0 = "100011") then
				OPSelect <= "010001";
			--srl
			elsif (IR_5_0 = "000010") then
				OPSelect <= "010101";
			--sll
			elsif (IR_5_0 = "000000") then
				OPSelect <= "011001";
			--sra
			elsif (IR_5_0 = "000011") then 
				OPSelect <= "010110";
			--jr
			elsif (IR_5_0 = "001000") then
				OPSelect <= "011011";
			--sltu
			elsif (IR_5_0 = "101011") then
				OPSelect <= "010111";
			end if;

			
		else 
			--andi
			if (ALUOP = "001100") then
				OPSelect <=	"010100"; 
			--addiu
			elsif (ALUOP = "001001") then
				OPSelect <= "010000";
			--subiu
			elsif (ALUOP = "010000") then
				OPSelect <= "010001";
			-- xori
			elsif (ALUOP = "001110") then
				OPSelect <= "011000";
			-- ori
			elsif (ALUOP = "001101") then
				OPSelect <= "011100";
			-- beq
			elsif (ALUOP = "000100") then
				OPSelect <= "000100";
			-- bne
			elsif (ALUOP = "000101") then
				OPSelect <= "000101";
			end if;
		end if;
		
		-- made own signal to increment PC
		if (ADD = '1') then
			OPSelect <= "010000";
		end if;
		
		if (NO_OP = '1') then
			OPSelect <= "011011";
		end if;
		
	end process;

end bhv;