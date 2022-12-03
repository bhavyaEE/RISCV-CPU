module ControlUnit #(
    parameter   DATA_WIDTH = 32
)(
    input  logic [DATA_WIDTH-1:0]  instr,
    input  logic                   EQ,
    output logic                   RegWrite,
    output logic [2:0]             ALUctrl,
    output logic                   ALUsrc,
    output logic [DATA_WIDTH-21:0] ImmSrc,
    output logic                   PCsrc
);

logic [6:0] opcode;
logic [6:0] funct7;
logic [2:0] funct3;

assign opcode = instr[6:0];
assign funct7 = instr[31:25];
assign funct3 = instr[14:12];

if (opcode==7'b0110011 && funct3==3'b000 && funct7==7'b000000) //add
    assign ALUctrl = 3'b000;
    assign ALUsrc = 1'b0;
    assign RegWrite = 1'b1; 

if (opcode==7'b0010011 && funct3==3'b000) //addi
    assign ALUctrl = 3'b000;
    assign ALUsrc = 1'b1;
    assign RegWrite = 1'b1;
    assign ImmSrc = instr[31:20];

if (opcode==7'b1100011 && funct3==3'b001) //bne
    assign ImmSrc = instr[31:20];
    assign RegWrite = 1'b0;
    if (EQ==0)
       assign  PCsrc = 1'b1;
    else
        assign PCsrc = 1'b0; 

endmodule   
     

    

