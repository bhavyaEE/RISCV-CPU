module PC_Reg (
    input logic [31:0]            next_PC,
    input logic                   rst,
    input logic                   clk, 
    output logic [31:0]           PC
);

logic [31:0] sreg;

always_ff @ (posedge clk, posedge rst)
    if (rst)
        sreg <= 32'b0;
    else 
        sreg <= next_PC;

assign PC = sreg;

endmodule


