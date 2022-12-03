  module Data_Memory #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32
)(
    input  logic                       clk,
    input  logic                       reset,
    input  logic  [ADDRESS_WIDTH-1:0]  addr,
    output logic  [DATA_WIDTH-1:0]     instr
);

logic  [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("Loading ram.");
        $readmemh("Sine.mem", ram_array);
end;

always_ff @(posedge clk, posedge reset)
begin
    instr <= ram_array [addr];
end

endmodule



