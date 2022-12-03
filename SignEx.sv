module SignEx (
    input logic [11:0] ImmSrc,
    input logic [31:0] instr,
    output logic [31:0] ImmOp
);

logic [4:0] rd;
logic  [6:0] opcode;
logic [19:0] imm;

assign  opcode = instr[6:0];
assign rd = instr[11:7];
assign imm = {{8{ImmSrc[11]}},ImmSrc};

if (opcode==7'b0010011) //addi
    assign ImmOp = {imm,rd,opcode};
if (opcode==7'b1100011) //bne
    assign ImmOp = {ImmSrc[11],ImmSrc[9:4],instr[24:12],ImmSrc[3:0],ImmSrc[10],opcode};

endmodule



