module PipelineCPU (
    input clk,
    input start,
    output signed [31:0] r [0:31]
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// The rst signal is active low, which means the module will reset if the rst signal is zero.
// And you should follow this design.

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
// you can modify it as you wish except I/O pin and register module

wire [31:0] pc_mux_out, pc_out, pc_plus4, ins_out, writeData, readData1, readData2, imm, imm_shift, adder2_sum, ALUmux_out, memRead_out, ALUOut;
wire [3:0] ALUCtrl;
wire [1:0] memtoReg, ALUOp, PCSel;
wire Brlt, Breq, memRead, memWrite, ALUSrc, regWrite, zero;

// new wire for pipeline cpu
wire [31:0] reg1_pc_o, reg1_pc_4_o, reg1_inst_out, reg2_pc_4, reg2_rd1, reg2_rd2, reg2_imm, reg3_pc_4, reg3_ALUResult, reg3_rd2, reg4_pc_4, reg4_ALUResult, reg4_readDataResult;
wire [4:0] reg2_writeReg, reg3_writeReg, reg4_writeReg;
wire [1:0] reg2_mem_to_reg, reg2_ALUop, reg3_mem_to_reg, reg4_mem_to_reg;
wire [2:0] reg2_funct3;
wire reg2_memWrite, reg2_memRead, reg2_ALUSrc, reg2_regWrite, reg2_funct7, reg3_memWrite, reg3_memRead, reg3_regWrite, reg4_regWrite; 

// new wire for lab4
wire flush_IF_ID, id_ForwardA, id_ForwardB, Flush_HD, RePC, isBranch, adder2_mux_sel;
wire [1:0] ex_ForwardA, ex_ForwardB;
wire [4:0] reg2_r1, reg2_r2, reg3_r1, reg3_r2;
wire [31:0] realData_1, realData_2, E_realData_1, E_realData_2, pc_mux_out2, pc_plus4_sub, add_object;


HazardDetection hazard_detection(
    .id_R1(reg1_inst_out[19:15]),
    .id_R2(reg1_inst_out[24:20]),
    .ex_Rd(reg2_writeReg),
    .mem_Rd(reg3_writeReg),
    .ex_MemRead(reg2_memRead),
    .ex_RegWrite(reg2_regWrite),
    .isBranch(isBranch),
    .RePC(RePC),
    .Flush_HD(Flush_HD)
);

Mux2to1 d_mux1(
    .sel(id_ForwardA),
    .s0(readData1),
    .s1(reg3_ALUResult),
    .out(realData_1)
);
Mux2to1 d_mux2(
    .sel(id_ForwardB),
    .s0(readData2),
    .s1(reg3_ALUResult),
    .out(realData_2)
);

Mux3to1 E_mux1(
    .sel(ex_ForwardA),
    .s0(reg2_rd1),
    .s1(writeData),
    .s2(reg3_ALUResult),
    .out(E_realData_1)
);

Mux3to1 E_mux2(
    .sel(ex_ForwardB),
    .s0(reg2_rd2),
    .s1(writeData),
    .s2(reg3_ALUResult),
    .out(E_realData_2)
);

Forwarding_Unit m_fowrardingUnit(
    .id_R1(reg1_inst_out[19:15]),
    .id_R2(reg1_inst_out[24:20]),
    .ex_R1(reg2_r1),
    .ex_R2(reg2_r2),
    .mem_Rd(reg3_writeReg),
    .wb_Rd(reg4_writeReg),
    .mem_RegWrite(reg3_regWrite),
    .wb_RegWrite(reg4_regWrite),
    .id_ForwardA(id_ForwardA),
    .id_ForwardB(id_ForwardB),
    .ex_ForwardA(ex_ForwardA),
    .ex_ForwardB(ex_ForwardB)
);

PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_mux_out2),
    .pc_o(pc_out)
);
Adder m_Adder_1(
    .a(pc_out),
    .b(4),
    .sum(pc_plus4)
);
Adder m_Adder_3(
    .a(pc_out),
    .b(-4),
    .sum(pc_plus4_sub)
);
InstructionMemory m_InstMem(
    .readAddr(pc_out),
    .inst(ins_out)
);
IF_ID_Reg IF_ID_reg(
    .clk(clk),
    .rst(start),
    .pc_i(pc_out),
    .pc_4_i(pc_plus4),
    .inst_i(ins_out),
    .pc_o(reg1_pc_o),
    .pc_4_o(reg1_pc_4_o),
    .inst_o(reg1_inst_out),
    .flush(flush_IF_ID),
    .flush2(Flush_HD)
);
Control m_Control(
    .opcode(reg1_inst_out[6:0]),
    .funct3(reg1_inst_out[14:12]),
    .BrEq(Breq),
    .BrLT(Brlt),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .PCSel(PCSel),
    .flush(flush_IF_ID),
    .isBranch(isBranch),
    .adder2_mux_sel(adder2_mux_sel)
);
ID_EX_Reg ID_EX_reg(
    .clk(clk),
    .rst(start),
    .flush(Flush_HD),
    .mem_to_reg_i(memtoReg),
    .ALUop_i(ALUOp),
    .memWrite_i(memWrite),
    .memRead_i(memRead),
    .ALUSrc_i(ALUSrc),
    .regWrite_i(regWrite),
    .funct7_i(reg1_inst_out[30]),
    .funct3_i(reg1_inst_out[14:12]),
    .pc_4_i(reg1_pc_4_o),
    .writeReg_i(reg1_inst_out[11:7]),
    .rd1_i(realData_1),
    .rd2_i(realData_2),
    .imm_i(imm),
    .mem_to_reg_o(reg2_mem_to_reg),
    .ALUop_o(reg2_ALUop),
    .memWrite_o(reg2_memWrite),
    .memRead_o(reg2_memRead),
    .ALUSrc_o(reg2_ALUSrc),
    .regWrite_o(reg2_regWrite),
    .funct7_o(reg2_funct7),
    .funct3_o(reg2_funct3),
    .pc_4_o(reg2_pc_4),
    .writeReg_o(reg2_writeReg),
    .rd1_o(reg2_rd1),
    .rd2_o(reg2_rd2),
    .imm_o(reg2_imm),
    .r1_i(reg1_inst_out[19:15]),
    .r2_i(reg1_inst_out[24:20]),
    .r1_o(reg2_r1),
    .r2_o(reg2_r2)
);

// For Student:
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(reg4_regWrite),
    .readReg1(reg1_inst_out[19:15]),
    .readReg2(reg1_inst_out[24:20]),
    .writeReg(reg4_writeReg),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation =======
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

BranchComp m_BranchComp(
    .A(realData_1),
    .B(realData_2),
    .BrEq(Breq),
    .BrLT(Brlt)
);

ImmGen m_ImmGen(
    .inst(reg1_inst_out),
    .imm(imm)
);

ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(imm_shift)
);

Mux2to1 adder2_mux(
    .sel(adder2_mux_sel),
    .s0(reg1_pc_o),
    .s1(realData_1),
    .out(add_object)
);
Adder m_Adder_2(
    .a(add_object),
    .b(imm),
    .sum(adder2_sum)
);
Mux3to1 #(.size(32)) m_Mux_PC(
    .sel(PCSel),
    .s0(pc_plus4),
    .s1(adder2_sum),
    .s2(ALUOut),
    .out(pc_mux_out)
);
Mux2to1 PC_mux2(
    .sel(RePC),
    .s0(pc_mux_out),
    .s1(pc_plus4_sub),
    .out(pc_mux_out2)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(reg2_ALUSrc),
    .s0(E_realData_2),
    .s1(reg2_imm),
    .out(ALUmux_out)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(reg2_ALUop),
    .funct7(reg2_funct7),
    .funct3(reg2_funct3),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(E_realData_1),
    .B(ALUmux_out),
    .ALUOut(ALUOut),
    .zero(zero)
);

EX_MEM_Reg EX_MEM_reg(
    .clk(clk),
    .rst(start),
    .mem_to_reg_i(reg2_mem_to_reg),
    .memWrite_i(reg2_memWrite),
    .memRead_i(reg2_memRead),
    .regWrite_i(reg2_regWrite),
    .pc_4_i(reg2_pc_4),
    .writeReg_i(reg2_writeReg),
    .ALU_result_i(ALUOut),
    .rd2_i(E_realData_2),
    .mem_to_reg_o(reg3_mem_to_reg),
    .memWrite_o(reg3_memWrite),
    .memRead_o(reg3_memRead),
    .regWrite_o(reg3_regWrite),
    .pc_4_o(reg3_pc_4),
    .writeReg_o(reg3_writeReg),
    .ALU_result_o(reg3_ALUResult),
    .rd2_o(reg3_rd2),
    .r1_i(reg2_r1),
    .r2_i(reg2_r2),
    .r1_o(reg3_r1),
    .r2_o(reg3_r2)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(reg3_memWrite),
    .memRead(reg3_memRead),
    .address(reg3_ALUResult),
    .writeData(reg3_rd2),
    .readData(memRead_out)
);

MEM_WB_Reg MEM_WB_reg(
    .clk(clk),
    .rst(start),
    .mem_to_reg_i(reg3_mem_to_reg),
    .regWrite_i(reg3_regWrite),
    .pc_4_i(reg3_pc_4),
    .writeReg_i(reg3_writeReg),
    .ALU_result_i(reg3_ALUResult),
    .readDataResult_i(memRead_out),
    .mem_to_reg_o(reg4_mem_to_reg),
    .regWrite_o(reg4_regWrite),
    .pc_4_o(reg4_pc_4),
    .writeReg_o(reg4_writeReg),
    .ALU_result_o(reg4_ALUResult),
    .readDataResult_o(reg4_readDataResult)
);

Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(reg4_mem_to_reg),
    .s0(reg4_ALUResult),
    .s1(reg4_readDataResult),
    .s2(reg4_pc_4),
    .out(writeData)
);

endmodule
