module PC_Reg (
    input logic [31:0]            next_PC,
    input logic                   rst,
    input logic                   clk, 
    output logic [31:0]           PC
);


always_ff @ (posedge clk, posedge rst)begin
   if(rst) PC <= {32'b0};
    else    PC <= next_PC;
end 

endmodule
