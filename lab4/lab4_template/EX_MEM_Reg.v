module EX_MEM_Reg (
    input wire clk,
    input wire rst,

    input wire [1:0] mem_to_reg_i,
    input wire memWrite_i,
    input wire memRead_i,
    input wire regWrite_i,
    input wire [31:0] pc_4_i,
    input wire [4:0] writeReg_i,
    input wire [31:0] ALU_result_i,
    input wire [31:0] rd2_i,

    output reg [1:0] mem_to_reg_o,
    output reg memWrite_o,
    output reg memRead_o,
    output reg regWrite_o,
    output reg [31:0] pc_4_o,
    output reg [4:0] writeReg_o,
    output reg [31:0] ALU_result_o,
    output reg [31:0] rd2_o,

    input wire [4:0] r1_i,
    input wire [4:0] r2_i,
    output reg [4:0] r1_o,
    output reg [4:0] r2_o
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            mem_to_reg_o <= mem_to_reg_o;
            memWrite_o <= memWrite_o;
            memRead_o <= memRead_o;
            regWrite_o <= regWrite_o;
            pc_4_o <= pc_4_o;
            writeReg_o <= writeReg_o;
            ALU_result_o <= ALU_result_o;
            rd2_o <= rd2_o;
            r1_o <= r1_o;
            r2_o <= r2_o;
        end 
        else begin
            mem_to_reg_o <= mem_to_reg_i;
            memWrite_o <= memWrite_i;
            memRead_o <= memRead_i;
            regWrite_o <= regWrite_i;
            pc_4_o <= pc_4_i;
            writeReg_o <= writeReg_i;
            ALU_result_o <= ALU_result_i;
            rd2_o <= rd2_i;
            r1_o <= r1_i;
            r2_o <= r2_i;
        end
    end

endmodule
