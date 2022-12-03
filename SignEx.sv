module SignEx (
    input  logic [2:0] ImmSrc,
    /* verilator lint_off UNUSED */
    input  logic [31:0] instr,
    /* verilator lint_on UNUSED */
    output logic [31:0] ImmOp
);


//logic [:]  _unused;


always_comb
    case(ImmSrc)
        000: ImmOp = {{20{instr[31]}}, instr[31:20]}; //addi
        001: ImmOp = {{20{instr[31]}}, instr[7],instr[30:25],instr[11:8],  1'b0}; //bne
        default: ImmOp = 32'b0;
    endcase 
    

endmodule


