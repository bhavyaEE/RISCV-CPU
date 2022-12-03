
module ControlUnit #(
    parameter   DATA_WIDTH = 32
)(
    /* verilator lint_off UNUSED */
    input  logic [DATA_WIDTH-1:0]  instr,
    /* verilator lint_on UNUSED */
    input  logic                   EQ,
    output logic                   RegWrite,
    output logic [2:0]             ALUctrl,
    output logic                   ALUsrc,
    output logic [2:0]             ImmSrc,
    output logic                   PCsrc
);

logic [6:0] opcode;
logic [2:0] funct3;
//logic [6:0] funct7;

assign opcode = instr[6:0];
assign funct3 = instr[14:12];
// assign funct7 = instr[31:25]; 
    


always_comb
    case (opcode)
        7'b0010011: 
        begin 
            case (funct3) //addi
                3'b000: 
                begin
                    ALUctrl = 3'b000;
                    ALUsrc = 1'b1;
                    RegWrite = 1'b1;
                    ImmSrc = 3'b000;
                    PCsrc = 1'b0;
                end 
                default: 
                begin
                    RegWrite = 1'b0;
                    ALUctrl = 3'b000;
                    ALUsrc = 1'b0;
                    ImmSrc = 3'b000;
                    PCsrc = 1'b0;
                end 
            endcase
        end     
        7'b1100011: 
        begin
                 ImmSrc = 3'b001; //bne
                 RegWrite = 1'b0;
                 ALUctrl = 3'b000;
                 ALUsrc = 1'b0;
            case (funct3)
                3'b001:
                begin 
                    case (EQ)
                        0: 
                        begin
                           PCsrc = 1'b1;
                        end 
                        1: 
                        begin
                           PCsrc = 1'b0;
                        end
                        default: 
                        begin
                            PCsrc = 1'b1;
                        end
                    endcase
                end 
                default: 
                begin
                    RegWrite = 1'b0;
                    ALUctrl = 3'b000;
                    ALUsrc = 1'b0;
                    ImmSrc = 3'b000;
                    PCsrc = 1'b0;
                end
            endcase
        end 
        default: 
        begin
            RegWrite = 1'b0;
            ALUctrl = 3'b000;
            ALUsrc = 1'b0;
            ImmSrc = 3'b000;
            PCsrc = 1'b0;
        end 
    endcase
                
endmodule






     

    

