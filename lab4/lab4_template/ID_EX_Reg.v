module ID_EX_Reg (
    input wire clk,
    input wire rst,
    input wire flush,

    input wire [1:0] mem_to_reg_i,
    input wire [1:0] ALUop_i,
    input wire memWrite_i,
    input wire memRead_i,
    input wire ALUSrc_i,
    input wire regWrite_i,
    input wire funct7_i,
    input wire [2:0] funct3_i,

    input wire [31:0] pc_4_i,
    input wire [4:0] writeReg_i,
    input wire [31:0] rd1_i,
    input wire [31:0] rd2_i,
    input wire [31:0] imm_i,

    output reg [1:0] mem_to_reg_o,
    output reg [1:0] ALUop_o,
    output reg memWrite_o,
    output reg memRead_o,
    output reg ALUSrc_o,
    output reg regWrite_o,
    output reg funct7_o,
    output reg [2:0] funct3_o,

    output reg [31:0] pc_4_o,
    output reg [4:0] writeReg_o,
    output reg [31:0] rd1_o,
    output reg [31:0] rd2_o,
    output reg [31:0] imm_o,

    input wire [4:0] r1_i,
    input wire [4:0] r2_i,
    output reg [4:0] r1_o,
    output reg [4:0] r2_o
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            mem_to_reg_o <= mem_to_reg_o;
            ALUop_o <= ALUop_o;
            memWrite_o <= memWrite_o;
            memRead_o <= memRead_o;
            ALUSrc_o <= ALUSrc_o;
            regWrite_o <= regWrite_o;
            funct7_o <= funct7_o;
            funct3_o <= funct3_o;
            pc_4_o <= pc_4_o;
            writeReg_o <= writeReg_o;
            rd1_o <= rd1_o;
            rd2_o <= rd2_o;
            imm_o <= imm_o;
            r1_o <= r1_o;
            r2_o <= r2_o;
        end
        else if (flush) begin
            mem_to_reg_o <= 2'b0;
            ALUop_o <= 2'b0;
            memWrite_o <= 1'b0;
            memRead_o <= 1'b0;
            ALUSrc_o <= 1'b0;
            regWrite_o <= 1'b0;
            funct7_o <= 1'b0;
            funct3_o <= 3'b0;
            pc_4_o <= 32'b0;
            writeReg_o <= 5'b0;
            rd1_o <= 32'b0;
            rd2_o <= 32'b0;
            imm_o <= 32'b0;
            r1_o <= 5'b0;
            r2_o <= 5'b0;
        end
        else begin
            mem_to_reg_o <= mem_to_reg_i;
            ALUop_o <= ALUop_i;
            memWrite_o <= memWrite_i;
            memRead_o <= memRead_i;
            ALUSrc_o <= ALUSrc_i;
            regWrite_o <= regWrite_i;
            funct7_o <= funct7_i;
            funct3_o <= funct3_i;
            pc_4_o <= pc_4_i;
            writeReg_o <= writeReg_i;
            rd1_o <= rd1_i;
            rd2_o <= rd2_i;
            imm_o <= imm_i;
            r1_o <= r1_i;
            r2_o <= r2_i;
        end
    end

endmodule
