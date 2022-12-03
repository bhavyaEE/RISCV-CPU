module Countermux (
  input logic [31:0]      PC,       
  input logic [11:0]      ImmOp, 
  input logic             PCsrc,
  output  logic [31:0]    next_PC  
);

logic  [31:0]       branch_PC;  
logic  [31:0]       inc_PC;

assign branch_PC = PC + ImmOp;
assign inc_PC = PC + 32'b100;
assign next_PC = PCsrc ? branch_PC : inc_PC;

endmodule 





