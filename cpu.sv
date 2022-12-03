module cpu #(
    parameter A_WIDTH = 32,
              D_WIDTH = 32
)(
    //interface signals
    input logic clk, 
    input logic rst, 
    output logic a0
);

    //connecting wires
logic [A_WIDTH-1:0] PC; 
logic [A_WIDTH-1:0] instr; 
logic PCsrc;
logic [2:0] ALUctrl; 
logic ALUsrc; 
logic EQ; 
logic regwrite; 
logic [11:0] Immsrc; 
logic [31:0] Immop; 
logic [4:0] rs1; 
logic [4:0] rs2; 
logic [4:0] rd; 


assign rs1 = instr[19:15];
assign rs2 = instr[24:20];
assign rd = instr[11:5]; 

InstrMem memory(
    .addr (PC),
    .instr (instr), 
    .clk (clk),
    .reset (rst)
);

SignEx immext(
    .ImmOp (Immop), 
    .ImmSrc (Immsrc),
    .instr(instr)
);

toppc pc (
    .clk (clk), 
    .rst (rst),
    .PC (PC),  
    .PCsrc (PCsrc),
    .ImmOp (Immop)
);

ControlUnit controlunit (
    .PCsrc (PCsrc), 
    .RegWrite (regwrite), 
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc), 
    .ImmSrc (Immsrc), 
    .EQ (EQ), 
    .instr (instr)
);

ALU alublock(
    .AD1 (rs1), 
    .AD2 (rs2), 
    .AD3 (rd),
    .WE3 (regwrite),
    .clk (clk), 
    .EQ (EQ), 
    .ALUctrl (ALUctrl),
    .ALUsrc (ALUsrc),
    .ImmOp (Immop), 
    .a0 (a0)
);
//secondtry
endmodule






