module SignEx (
    input  logic [ 2:0] ImmSrc,
    /* verilator lint_off UNUSED */
    input  logic [31:0] instr,
    /* verilator lint_on UNUSED */
    output logic [31:0] ImmOp
);


  //logic [:]  _unused;



  always_comb
    /* verilator lint_off WIDTH */
    case (ImmSrc)
      /* verilator lint_on WIDTH */
      3'b000:  ImmOp = {{20{instr[31]}}, instr[31:20]};  //addi [I]
      3'b001:  ImmOp = {{20{instr[31]}}, instr[31:25], instr[11:7]};  //[S]
      3'b010:  ImmOp = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};  //bne [B]
      3'b011:  ImmOp = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};  //jal [J]
      default: ImmOp = 32'b0;
    endcase



endmodule


