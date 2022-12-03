module mux(
    input   logic [31:0]      regOp2, ImmOp,
    input   logic             ALUsrc,
    output  logic [31:0]       ALUop2

);

    assign ALUop2 = ALUsrc ? regOp2 : ImmOp;
endmodule

