module PC (
    input clk,
    input rst,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

    always @(negedge clk, negedge rst) begin
        if(~rst) pc_o <= pc_o;  //rst = 0 don't continue
        else pc_o <= pc_i;      //move to next step
    end

endmodule




