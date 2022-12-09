module Data_Memory #(
    parameter DATA_WIDTH = 32
) (
    /* verilator lint_off UNUSED */
    input  logic [DATA_WIDTH-1:0] ALUout,
    /* verilator lint_on UNUSED */
    input  logic                  WE,
    input  logic [DATA_WIDTH-1:0] WD,
    input  logic                  clk,
    output logic [DATA_WIDTH-1:0] RD
);

  logic [DATA_WIDTH-1:0] datamem_array[2**17-1:0];

  always_ff @(posedge clk) begin
    if (WE) datamem_array[ALUout] <= WD;
  end

  always_comb begin
    RD = datamem_array[ALUout];
  end


endmodule



