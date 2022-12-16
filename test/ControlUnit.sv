
module ControlUnit #(
    parameter DATA_WIDTH = 32
) (
    /* verilator lint_off UNUSED */
    input  logic [DATA_WIDTH-1:0] instr,
    /* verilator lint_on UNUSED */
    input  logic                  EQ,
    output logic                  RegWrite,
    output logic [           2:0] ALUctrl,
    output logic                  ALUsrc,
    output logic [           2:0] ImmSrc,
    output logic                  PCsrc,
    output logic                  jalrsel,
    output logic                  MemWrite,
    output logic                  ResultSrc,
    output logic                  jal_sel
);

  logic [6:0] opcode;
  logic [2:0] funct3;
  // logic jregen; 
  // logic [2:0] dummy; 
  //logic [6:0] funct7;

  assign opcode = instr[6:0];
  assign funct3 = instr[14:12];
  // assign funct7 = instr[31:25]; 

  always_comb begin
    if (opcode == 7'b1100011 && funct3 == 3'b001) begin
      // bne
      PCsrc = !EQ;
    end else if (opcode == 7'b1100111 && funct3 == 3'b000) begin
      // jalr
      PCsrc = 1;
    end else if (opcode == 7'b1101111) begin
      // jal
      PCsrc = 1;
    end else begin
      PCsrc = 0;
    end
  end

  always_comb begin
    case (opcode)
      7'b1100011: begin
        ImmSrc = 3'b010;  //bne
        RegWrite = 1'b0;
        ALUsrc = 1'b0;
        ALUctrl = 3'b000;
        jal_sel = 1'b0;
        jalrsel = 1'b0;
        MemWrite = 1'b0;
        ResultSrc = 1'b0;
      end
      7'b1101111: begin
        //jal
        ImmSrc = 3'b011;  //jal ImmSrc code
        RegWrite = 1'b1;  //needs to be high to store return address
        ALUsrc = 1'b0;  //doesn't matter
        jal_sel = 1'b1;
        ALUctrl = 3'b000;
        jalrsel = 1'b0;
        MemWrite = 1'b0;
        ResultSrc = 1'b0;
      end
      7'b1100111: begin
        case (funct3)  //ret implemented with jalr with rd as x0
          3'b000: begin
            ALUsrc = 1'b1;  //needs to be high so offset added to register 
            RegWrite = 1'b1;  //high
            ImmSrc = 3'b000;
            jalrsel = 1'b1;
            ALUctrl = 3'b000;
            jal_sel = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
          end
          default: begin
            //same as default from previous cases
            RegWrite = 1'b0;
            ALUsrc = 1'b0;
            ImmSrc = 3'b000;
            jalrsel = 1'b0;
            ALUctrl = 3'b000;
            jal_sel = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
          end
        endcase
      end
      7'b0010011: begin
        case (funct3)  //addi
          3'b000: begin
            ALUsrc = 1'b1;
            RegWrite = 1'b1;
            ImmSrc = 3'b000;
            ALUctrl = 3'b000;
            jalrsel = 1'b0;
            jal_sel = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
          end
          3'b001: begin
            ImmSrc = 3'b000;  //shift//
            RegWrite = 1'b1;
            ALUctrl = 3'b001;
            ALUsrc = 1'b1;
            jalrsel = 1'b0;
            jal_sel = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
          end
          default: begin
            RegWrite = 1'b0;
            ALUsrc = 1'b0;
            ImmSrc = 3'b000;
            ALUctrl = 3'b000;
            jalrsel = 1'b0;
            jal_sel = 1'b0;
            MemWrite = 1'b0;
            ResultSrc = 1'b0;
          end
        endcase
      end
      7'b0000011: //load 
        begin
        ALUsrc = 1'b1;
        RegWrite = 1'b1;
        ImmSrc = 3'b000;
        ALUctrl = 3'b000;
        MemWrite = 1'b0;
        ResultSrc = 1'b1;
      end
      7'b0100011: //store
        begin
        ALUsrc = 1'b1;
        RegWrite = 1'b0;
        ImmSrc = 3'b001;
        ALUctrl = 3'b000;
        MemWrite = 1'b1;
        ResultSrc = 1'b0;
      end
      default: begin
        RegWrite = 1'b0;
        ALUsrc = 1'b0;
        ImmSrc = 3'b000;
        ALUctrl = 3'b000;
        MemWrite = 1'b0;
        ResultSrc = 1'b0;
        jalrsel = 1'b0;
        jal_sel = 1'b0;
        PCsrc = 0;
      end
    endcase
  end

endmodule

// always_comb begin
//     // if (jal_sel || jalrsel) jregen = 1; 
//     // else jregen = 0; 
//     // if (opcode == 7'b1100011) dummy = 001; //shift dummy variable 
//     // else dummy = 000; 
//     case (opcode)

//         default: 
//         begin
//             // RegWrite = jregen;
//             // ALUctrl = 3'b000;
//             // ALUsrc = 1'b0;
//             // ImmSrc = dummy;
//             //MemWrite =1'b0;
//             //ResultSrc =1'b0;
//         end 

//     endcase
// end

// endmodule












