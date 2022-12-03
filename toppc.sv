module toppc (          
  input logic  [31:0]      ImmOp,
  input logic              rst,   
  input logic              PCsrc,
  input logic              clk,
  output logic  [31:0]     PC
);

  logic  [31:0]        next_PC;    

Countermux Countermux ( 
  .PC (PC),
  .ImmOp (ImmOp),
  .next_PC (next_PC),
  .PCsrc (PCsrc)
);

PC_Reg  PC_Reg( 
  .rst (rst),
  .next_PC (next_PC),
  .clk (clk),
  .PC (PC)
);

endmodule

