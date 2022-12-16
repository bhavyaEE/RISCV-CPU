module alu_(
    input   logic [31:0]      ALUop1, 
    input logic [31:0] ALUop2,
    input   logic [2:0]            ALUctrl,
    output  logic [31:0]       ALUout,
    output  logic               EQ

);


always_comb begin
    case (ALUctrl)
    3'b000:     ALUout = ALUop1 + ALUop2;
    3'b001: ALUout = ALUop1 << ALUop2;
    3'b010: ALUout = 32'b0;
    3'b011: ALUout = 32'b0;
    3'b100: ALUout = 32'b0;
    3'b101: ALUout = 32'b0;
    3'b110: ALUout = 32'b0;
    default:    ALUout = 0;
    endcase
end

assign      EQ = (ALUop1 == ALUop2);
    

endmodule

