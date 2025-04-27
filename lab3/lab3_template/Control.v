module Control (
    input [6:0] opcode,
    input [2:0] funct3,
    input BrEq, BrLT,
    output reg memRead,
    output reg [1:0] memtoReg,
    output reg [1:0] ALUOp,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite,
    output reg [1:0] PCSel
);
    reg [9:0] ctrl;
    assign {PCSel, memRead, memtoReg, ALUOp, memWrite, ALUSrc, regWrite} = ctrl;
    // TODO: implement your Control here
    // Hint: follow the Architecture (figure in spec) to set output signal
    always @(*) begin
        case(opcode)           //PCSel_memRead_memtoReg_ALUop_memWrite_ALUSrc_regWrite
            7'b0110011: ctrl = 10'b00_0_00_11_0_0_1; //R-type (add, sub, and, or, slt)
            7'b0010011: ctrl = 10'b00_0_00_01_0_1_1; //I-type (addi, andi, ori)
            7'b0000011: ctrl = 10'b00_1_01_10_0_1_1; //lw
            7'b0100011: ctrl = 10'b00_0_xx_10_1_1_0; //sw
            7'b1101111: ctrl = 10'b01_0_10_10_0_1_1; //jal(pc not sure)(mem_to_reg = 2 pc+4 to rd)
            7'b1100111: ctrl = 10'b10_0_10_10_0_1_1; //jalr
            7'b1100011:
                case(funct3)
                    3'b000: ctrl = (BrEq == 1) ? 10'b01_0_xx_10_0_1_0 : 10'b00_0_xx_10_0_1_0; //beq
                    3'b001: ctrl = (BrEq == 0) ? 10'b01_0_xx_10_0_1_0 : 10'b00_0_xx_10_0_1_0; //bne
                    3'b100: ctrl = (BrLT == 1) ? 10'b01_0_xx_10_0_1_0 : 10'b00_0_xx_10_0_1_0; //blt
                    3'b101: ctrl = (BrLT == 0) ? 10'b01_0_xx_10_0_1_0 : 10'b00_0_xx_10_0_1_0; //bge
                    default: ctrl = 10'b0000000000;
                endcase
            default: ctrl = 10'b0000000000;
        endcase
    end

endmodule

