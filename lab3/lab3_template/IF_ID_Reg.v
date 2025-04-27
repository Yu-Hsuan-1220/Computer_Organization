module IF_ID_Reg (
    input wire clk,
    input wire rst,
    input wire [31:0] pc_i,
    input wire [31:0] pc_4_i,
    input wire [31:0] inst_i,
    output reg [31:0] pc_o,
    output reg [31:0] pc_4_o,
    output reg [31:0] inst_o
);
    // TODO:
    // Besides the IF/ID stage register provided in the template file,
    // you will also need to create other stage registers such as ID/EX, EX/MEM, MEM/WB, etc.

    // Hint:
    // There are two approaches to implement the stage registers:
    // 1. Use a generic Pipeline Register module to instantiate the registers for each stage,
    //    where each Pipeline Register handles only one type of data. This approach is modular,
    //    making it easy to modify later.
    // 2. Directly specialize the Pipeline Register into distinct modules for each stage,
    //    which makes the design more intuitive and easier to understand.
    // Choose the design approach that best suits your needs.

    always @(posedge clk, negedge rst) begin
        if(~rst) begin
            pc_o <= pc_o;
            pc_4_o <= pc_4_o;
            inst_o <= inst_o;
        end
        else begin
            inst_o <= inst_i;
            pc_o <= pc_i;
            pc_4_o <= pc_4_i;
        end
    end



endmodule
