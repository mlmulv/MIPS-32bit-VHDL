library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_controller is
	port (
		clk : in std_logic;
		rst : in std_logic;
		IR_31_26 : in std_logic_vector(5 downto 0);
		IR_15_0 : in std_logic_vector (15 downto 0);
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
		ALUOp : out std_logic_vector(5 downto 0);
		ALUSrcB : out std_logic_vector(1 downto 0);
		ALUSrcA : out std_logic;
		RegWrite :out std_logic;
		RegDst : out std_logic;
		LO_en : out std_logic;
		HI_en : out std_logic;
		ADD : out std_logic;
		NO_OP : out std_logic
	);
end mips_controller;

architecture bhv of mips_controller is 
signal IR_5_0 : std_logic_vector(5 downto 0);

type state_t is (instr_fetch_1, instr_fetch_2, instr_decode, rtype_1, rtype_2, rtype_3, lw_1, lw_2, lw_3, lw_4, itype_1, itype_2, rw_2, jump, jump_r, jumpnlink_1, jumpnlink_2,branch_1,branch_2);
signal state, next_state : state_t;

begin

	process(rst,clk)
	begin
		if (rst = '1') then
			state <= instr_fetch_1;
			
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
	end process;
	
	process (state, IR_31_26, IR_15_0,IR_5_0)
	begin
		next_state <= state;
		PCWriteCond <= '0';
		PCWrite <= '0';
		IorD <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		MemtoReg <= '0';
		IRWrite <= '0';
		JumpandLink <= '0';
		IsSigned <= '0';
		PCSource <= "00";
		ALUOp <= "000000";
		ALUSrcB <= "00";
		ALUSrcA <= '0';
		RegWrite <= '0';
		RegDst <= '0';
		ADD <= '0';
		NO_OP <= '0';
		LO_en <= '0';
		HI_en <= '0';

		IR_5_0 <= IR_15_0(5 downto 0);
		
		case(state) is
			when instr_fetch_1 =>
				MemWrite <= '0';
				IorD <= '0';
				next_state <= instr_fetch_2;
				
			when instr_fetch_2 =>
				-- Getting instruction from RAM
				IRWrite <= '1';
				
				-- Incrementing PC by 4
				ALUSrcA <= '0';
				ALUSrcB <= "01";
				ADD <= '1'; -- sending add
				PCSource <= "00";
				
				-- Updating PC
				PCWrite <= '1';
				next_state <= instr_decode;
				
			when instr_decode =>
				ADD <= '0';
				IRWrite <= '0';
				PCWrite <= '0';
				
				if (IR_31_26 = "000000") then
					
					next_state <= rtype_1; -- only testing fetch and decode
					ALUOp <= "000000";
					
					if (IR_5_0 = "001000") then
						next_state <= jump_r;
					end if;
					
				elsif (IR_31_26 = "100011" or IR_31_26 = "101011") then  
					next_state <= lw_1;
				elsif (IR_31_26 = "000010") then
					next_state <= jump;
				elsif (IR_31_26 = "000011") then
					next_state <= jumpnlink_1;
					ALUOp <= "000000";
				elsif (IR_31_26 = "000100" or IR_31_26 = "000101") then
					next_state <= branch_1;
					ALUOp <= "000100";
				else
					next_state <= itype_1;
					ALUOp <= IR_31_26;
				end if;
				
				
				
			when lw_1 =>
				IsSigned <= '0';
				ALUSrcA <= '1';
				ALUSrcB <= "10";
				ADD <= '1';
				next_state <= lw_2;
				if (IR_31_26 = "101011") then
					next_state <= rw_2;
				end if;
				
			when lw_2 =>
				IorD <= '1';
				MemWrite <= '0';
				next_state <= lw_3;
				
			when lw_3 =>
				next_state <= lw_4;
				
			when lw_4 =>
				MemtoReg <= '1';
				RegWrite <= '1';
				RegDst <= '0';
				next_state <= instr_fetch_1;
				
			when rw_2 =>
				IorD <= '1';
				MemWrite <= '1';
				next_state <= instr_fetch_1;
				
			when rtype_1 =>
				next_state <= rtype_2;
				
			when rtype_2 =>
				ALUSrcA <= '1';
				ALUSrcB <= "00";
				ALUOp <= "000000";
				next_state <= rtype_3;
				
				-- setting LO and HI reg enables high
				if (IR_5_0 = "011001" or IR_5_0 = "011000") then
					LO_en <= '1'; 
					HI_en <= '1';	
				end if;
			
			when rtype_3 => 
				-- setting ALU_LO_HI -- ALU_LO_HI should be one clock cyle late?
				if (IR_5_0 /= "010010" and IR_5_0 /= "010000" ) then -- for move hi and move low
					ALUOp <= "111111"; -- instruction to set ALU_LO_HI to ALU_OUT
				end if;
				LO_en <= '0';
				HI_en <= '0';
				MemtoReg <= '0';
				RegDst <= '1';
				RegWrite <= '1';
				next_state <= instr_fetch_1;
				
			when itype_1 =>
				IsSigned <= '0'; -- JUST FOR ANDI NEED TO CHANGE THIS FOR OTHER INSTRUCTIONS
				next_state <= itype_2;
				ALUSrcB <= "10";
				ALUSrcA <= '1';
				ALUOp <= IR_31_26; 
				
			when itype_2 =>
				
				ALUOp <= "111111"; -- instruction to set ALU_LO_HI to ALU_OUT
				MemtoReg <= '0';
				RegDst <= '0';
				RegWrite <= '1';
				next_state <= instr_fetch_1;
				
	
			when jump =>
				PCSource <= "10";
				PCWrite <= '1';
				next_state <= instr_fetch_1;
				
			when jump_r=>
				ALUSrcA <= '1';
				NO_OP <= '1';
				PCSource <= "00";
				PCWrite <= '1';
				next_state <= instr_fetch_1;
				
			
			when jumpnlink_1 =>
				ALUSrcA <= '0';
				NO_OP <= '1';
				next_state <= jumpnlink_2;
				
			when jumpnlink_2 =>
				MemtoReg <= '0';
				RegWrite <= '1';
				JumpandLink <= '1';
				PCSource <= "10";
				PCWrite <= '1';
				next_state <= instr_fetch_1;
				
			when branch_1 =>
				IsSigned <= '0';
				ALUSrcB <= "11";
				ALUSrcA <= '0';
				ADD <= '1';
				next_state <= branch_2;
				
			when branch_2 =>
				ALUSrcA <= '1';
				ALUSrcB <= "00"; 
				PCWriteCond <= '1';
				PCSource <= "01";
				-- if beq
				if (IR_31_26 = "000100") then
					ALUOP <= "000100";
				elsif (IR_31_26 = "000101") then
					ALUOP <= "000101";
				end if;
				next_state <= instr_fetch_1;
				
				
			
		end case;
		
	end process;
end bhv;