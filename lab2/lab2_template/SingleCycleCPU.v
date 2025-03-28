module SingleCycleCPU (
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


PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_mux_out),
    .pc_o(pc_out)
);

Adder m_Adder_1(
    .a(pc_out),
    .b(4),
    .sum(pc_plus4)
);


InstructionMemory m_InstMem(
    .readAddr(pc_out),
    .inst(ins_out)
);

Control m_Control(
    .opcode(ins_out[6:0]),
    .funct3(ins_out[14:12]),
    .BrEq(Breq),
    .BrLT(Brlt),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite),
    .PCSel(PCSel)
);

// For Student:
// Do not change the Register instance name!
// Or you will fail validation.

Register m_Register(
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(ins_out[19:15]),
    .readReg2(ins_out[24:20]),
    .writeReg(ins_out[11:7]),
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);

// ======= for validation =======
// == Dont change this section ==
assign r = m_Register.regs;
// ======= for vaildation =======

BranchComp m_BranchComp(
    .A(readData1),
    .B(readData2),
    .BrEq(Breq),
    .BrLT(Brlt)
);

ImmGen m_ImmGen(
    .inst(ins_out),
    .imm(imm)
);


ShiftLeftOne m_ShiftLeftOne(
    .i(imm),
    .o(imm_shift)
);

Adder m_Adder_2(
    .a(pc_out),
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


Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm),
    .out(ALUmux_out)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(ins_out[30]),
    .funct3(ins_out[14:12]),
    .ALUCtl(ALUCtrl)
);

ALU m_ALU(
    .ALUctl(ALUCtrl),
    .A(readData1),
    .B(ALUmux_out),
    .ALUOut(ALUOut),
    .zero(zero)
);


DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),
    .writeData(readData2),
    .readData(memRead_out)
);


Mux3to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s0(ALUOut),
    .s1(memRead_out),
    .s2(pc_plus4),
    .out(writeData)
);

endmodule
