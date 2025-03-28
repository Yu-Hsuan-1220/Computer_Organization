module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);

    // TODO: implement your ALU control here
    // For testbench verifying, Do not modify input and output pin
    // Hint: using ALUOp, funct7, funct3 to select exact operation
    always @(*) begin
        case(ALUOp)
            2'b10 : case({funct7,funct3})
                        {1'b0, 3'b000} : ALUCtl = 4'b0010; //add
                        {1'b1, 3'b000} : ALUCtl = 4'b0110; //SUB
                        {1'b0, 3'b111} : ALUCtl = 4'b0000;
                        {1'b0, 3'b110} : ALUCtl = 4'b0001;
                        {1'b0, 3'b010} : ALUCtl = 4'b0111;
                        default : ALUCtl = 4'bxxxx;
                    endcase
            2'b11 : case(funct3)
                        3'b000 : ALUCtl = 4'b0010;
                        3'b111 : ALUCtl = 4'b0000;
                        3'b110 : ALUCtl = 4'b0001;
                        3'b010 : ALUCtl = 4'b0111;
                        default : ALUCtl = 4'bxxxx;
                    endcase
            2'b00 : case(funct3)
                        3'b010 : ALUCtl = 4'b0010;
                        3'b000 : ALUCtl = 4'b0010;
                        default : ALUCtl = 4'bxxxx;
                    endcase
            2'b01 : case(funct3)
                        // TODO
                        default : ALUCtl = 4'bxxxx;
                    endcase
            default : ALUCtl = 4'bxxxx;
        endcase
    end


endmodule

