module toppc (          
  input logic  [31:0]      ImmOp,
  input logic              rst,   
  input logic              PCsrc,
  input logic              clk,
  output logic  [31:0]     PC
);
  

logic [31:0]  inc_PC;
logic [31:0]  branch_PC;
logic [31:0]  next_PC;
assign inc_PC = PC+4;
assign branch_PC = PC + ImmOp;

assign next_PC = PCsrc ? branch_PC : inc_PC;

PC_Reg  PC_Reg( 
  .rst (rst),
  .next_PC (next_PC),
  .clk (clk),
  .PC (PC)
);

endmodule

