module ALU #(
    parameter A_WIDTH = 5,
    D_WIDTH = 32
) (
    // interface signals
    input  logic               clk,
    input  logic [       31:0] pc,
    input  logic               ALUsrc,
    input  logic [        2:0] ALUctrl,
    input  logic [       31:0] ImmOp,
    input  logic               WE3,
    input  logic [A_WIDTH-1:0] AD1,
    input  logic [A_WIDTH-1:0] AD2,
    input  logic [A_WIDTH-1:0] AD3,
    output logic               EQ,
    output logic [D_WIDTH-1:0] sum,
    input  logic               MemWrite,
    input  logic               ResultSrc,
    output logic [D_WIDTH-1:0] a0,
    input  logic               jal_sel

);

  logic [D_WIDTH-1:0] regOp2;
  logic [D_WIDTH-1:0] ALUop1;
  logic [D_WIDTH-1:0] ALUop2;
  logic [D_WIDTH-1:0] ALUout;
  logic [D_WIDTH-1:0] ReadData;
  logic [D_WIDTH-1:0] rd_input, writedata;




  always_comb begin
    //assign Result = ResultSrc ?  ReadData : ALUout; //mux 
    assign rd_input = jal_sel ? pc + 4 : ALUout;
    assign writedata = ResultSrc ? ReadData : rd_input;
  end



  Reg_file regfile (
      .clk(clk),
      .AD1(AD1),
      .AD2(AD2),
      .AD3(AD3),
      .WE3(WE3),
      .RD1(ALUop1),
      .RD2(regOp2),
      .WD3(writedata),
      .a0 (a0)
  );


  assign ALUop2 = ALUsrc ? ImmOp : regOp2;
  assign sum = ALUout;


  alu_ addralu (
      .ALUop1(ALUop1),
      .ALUop2(ALUop2),
      .EQ(EQ),
      .ALUctrl(ALUctrl),
      .ALUout(ALUout)
  );

  Data_Memory data_memory (
      .clk(clk),
      .ALUout(ALUout),
      .WE(MemWrite),
      .WD(regOp2),
      .RD(ReadData)
  );




endmodule








