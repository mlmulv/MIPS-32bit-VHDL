library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mips_datapath is
	generic (
		WIDTH : positive := 32
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		switches : in std_logic_vector(9 downto 0);
		inPort0_en : in std_logic;
	    inPort1_en : in std_logic;
		outPort : out std_logic_vector(31 downto 0)
		
	);
end mips_datapath;

architecture bhv of mips_datapath is 

signal IR_31_26 : std_logic_vector(5 downto 0);
signal IR_25_0 : std_logic_vector(25 downto 0);
signal IR_25_21 : std_logic_vector(25 downto 21);
signal IR_20_16 : std_logic_vector(20 downto 16);
signal IR_15_11 : std_logic_vector(15 downto 11);
signal IR_15_0 : std_logic_vector(15 downto 0);
signal PCWriteCond, PCWrite, MemWrite, IorD, MemtoREg, IRWrite, JumpAndLink, IsSigned, ALUScrA, RegWrite, RegDst : std_logic;
signal OutPCMuxIn, OutPC : std_logic_vector(WIDTH-1 downto 0);
signal BranchTaken, OUTAND, OUTOR : std_logic;
signal OutPCMuxOut,OutMuxAlu,Result, Result_Hi, inPort : std_logic_vector(WIDTH-1 downto 0);
signal OutMem, OutMemReg : std_logic_vector(WIDTH-1 downto 0);
signal  WriteData : std_logic_vector(WIDTH -1 downto 0);
signal InRegA,InRegB,OutRegA, OutRegB : std_logic_vector(WIDTH-1 downto 0);
signal ALUInputA, ALUInputB, OutSignExt, Shift2LeftExtendOut: std_logic_vector (WIDTH-1 downto 0);
signal OPSelect : std_logic_vector (5 downto 0);
signal ALUOut, ALUOutHi, ALUOutLo : std_logic_vector (WIDTH-1 downto 0);
signal ALUOp : std_logic_vector(3 downto 0);
signal ALU_LO_HI : std_logic_vector(1 downto 0);
signal IN_CONC : std_logic_vector(27 downto 0);
signal OUT_CONC : std_logic_vector(WIDTH-1 downto 0);
signal PCSource, ALUSrcB : std_logic_vector(1 downto 0);
signal WriteReg : std_logic_vector(4 downto 0);

begin

	MIPS_CONTROLLER : entity work.mips_controller port map (
		IR_31_26 => IR_31_26,		
		PCWriteCond => PCWriteCond,  
		PCWrite => PCWrite,
		MemWrite => MemWrite,
		MemtoReg => MemtoReg,
		IRWrite => IRWRite,
		JumpandLink => JumpandLink,
		IsSigned => IsSigned,
		PCSource => PCSource,
		ALUOp => ALUOp,
		ALUSrcB => ALUSrcB,
		ALUScrA => ALUScrA,
		RegWrite => RegWrite,
		IorD => IorD,
		RegDst => RegDst);
		
	PC : entity work.reg_async_rst port map (
		input => OutPCMuxIn,
		output => OutPC,
		clk => clk,
		rst => rst,
		en => OUTOR);
		
	AND1 : entity work.andtwo port map (
		input1 => BranchTaken,
		input2 => PCWriteCond,
		output => OUTAND);
		
	OR1 : entity work.ortwo port map (
		input1 => OUTAND,
		input2 => PCWrite,
		output => OUTOR);
		
	PCMuxOut : entity work.generic_mux1 generic map (
		WIDTH => WIDTH)
		port map (
		input1 => OutPC,
		input2 => ALUOut,
		output => OutPCMuxOut,
		sel => IorD);
		
	Memory : entity work.memory_mips generic map (
		WIDTH => WIDTH)
		port map (
		clk => clk,
		rst => rst,
		mem_address => OutPCMuxOut,
		inPort => inPort,
		inPort0_en => inPort0_en,
	    inPort1_en => inPort1_en,
		input => OutRegB,
		outPort => outPort,
		memwrite => memwrite,
		output => OutMem);
		
	Zero_Extend : entity work.zero_extend port map (
		input => switches,
		output => inPort);
				
	Instruction_Register : entity work.instruction_register 
		port map (
		input => OutMem,
		IR_31_26 => IR_31_26,
		IR_25_0 => IR_25_0, 
		IR_25_21 => IR_25_21, 
		IR_20_16 => IR_20_16, 
		IR_15_11 => IR_15_11, 
		IR_15_0 => IR_15_0);

	Memory_Data_Register : entity work.reg_async_rst generic map (
		WIDTH => WIDTH)
		port map (
		input => OutMem,
		output => OutMemReg,
		clk => clk,
		rst => rst,
		en => '1');
		
	Mux_Write_Reg : entity work.generic_mux1 generic map (
		WIDTH => 5)
		port map (
		input1 => IR_20_16,
		input2 => IR_15_11,
		sel => RegDst,
		output => WriteReg);
		
	Mux_Write_Data: entity work.generic_mux1 generic map (
		WIDTH => WIDTH)
		port map (
		input1 => OutMuxAlu,
		input2 => OutMemReg,
		sel => MemtoReg,
		output => WriteData);
		
	Registers_File : entity work.register_file port map (
		IR_25_21 => IR_25_21,
		IR_20_16 => IR_20_16,
		WriteReg => WriteReg,
		WriteData => WriteData,
		IsSigned => IsSigned,
		JumpAndLink => JumpAndLink,
		Data1 => InRegA,
		Data2 => InRegB);
		
	RegA : entity work.reg_async_rst generic map (
		WIDTH => WIDTH)
		port map (
		input => InRegA,
		output => OutRegA,
		clk => clk,
		rst => rst,
		en => '1');
		
	RegB : entity work.reg_async_rst generic map (
		WIDTH => WIDTH)
		port map (
		input => InRegB,
		output => OutRegB,
		clk => clk,
		rst => rst,
		en => '1');
		
	RegA_Mux : entity work.generic_mux1 generic map (
		WIDTH => WIDTH)
		port map (
		input1 => OutPCMuxOut,
		input2 => OutRegA,
		output => ALUInputA,
		sel => ALUScrA);
		
	RegB_Mux : entity work.mux_4x2 generic map (
		WIDTH => WIDTH)
		port map (
		input1 => OutRegB,
		input2 => x"00000004",
		input3 => OutSignExt,
		input4 => Shift2LeftExtendOut,
		output => ALUInputB,
		sel => ALUSrcB);
		
	Sign_Extend : entity work.sign_extend port map (
		input => IR_15_0,
		output => OutSignExt,
		IsSigned => IsSigned);
		
	Shift_2_Extend : entity work.shift_left_no_add 
		port map (
		input => OutSignExt,
		output => Shift2LeftExtendOut);
		
	ALU : entity work.alu_mips generic map (
		WIDTH => WIDTH)
		port map (
		alu_input1 => ALUInputA,
		alu_input2 => ALUInputB,
		op => OPSelect,
		shift => IR_15_0(10 downto 6),
		result => Result,
		result_hi => Result_Hi,
		branch_taken => BranchTaken);
		
	ALUOutReg : entity work.reg_async_rst generic map (
		WIDTH => WIDTH)
		port map (
		input => Result,
		output => ALUOut,
		clk => clk,
		rst => rst,
		en => '1');
		
	ALU_OUT_LO : entity work.reg_async_rst generic map (
		WIDTH => WIDTH)
		port map (
		input => ALUOut,
		output => ALUOutLo,
		clk => clk,
		rst => rst,
		en => '1');
		
		
	ALU_OUT_HI : entity work.reg_async_rst generic map (
		WIDTH => WIDTH)
		port map (
		input => Result_Hi,
		output => ALUOutHi,
		clk => clk,
		rst => rst,
		en => '1');
		
	ALU_MUX : entity work.mux_4x2 generic map (
		WIDTH => WIDTH)
		port map (
		input1 => ALUOut,
		input2 => ALUOutLo,
		input3 => ALUOutLo,
		input4 => x"00000000",
		sel => ALU_LO_HI,
		output => OutMuxAlu);
		
	ALU_CONTROLLER : entity work.alu_control port map (
		IR_5_0 => IR_15_0(5 downto 0),
		OPSelect => OPSelect, 
		ALU_LO_HI => ALU_LO_HI,
		ALUOp => ALUOp);
	
	SHIFT_2_CONC : entity work.shift_two generic map (
		IN_WIDTH => 26)
		port map (
		input => IR_25_0,
		output => IN_CONC);
		
	CONCAT : entity work.concat port map (
		input => IN_CONC,
		pc => OUTPC(31 downto 28),
		output => OUT_CONC);
	
	MUX_IN_PC : entity work.mux_4x2 generic map (
		WIDTH => WIDTH)
		port map (
		input1 => Result,
		input2 => ALUOut,
		input3 => OUT_CONC,
		input4 => x"00000000",
		sel => PCSource,
		output => OutPCMuxIn);
	
end bhv;