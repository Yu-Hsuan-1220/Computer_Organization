module BranchComp (
    input signed [31:0] A,B,
    output reg BrEq, BrLT
);
// BranchComp compares two inputs and then outputs BrEq and BrLT based on the result.
// TODO: implement your BranchComp here
// Hint: you can use operator to implement
    assign BrEq = (A == B)? 1 : 0;
    assign BrLT = (A < B)? 1 : 0;
endmodule
