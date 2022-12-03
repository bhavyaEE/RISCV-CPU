module InstrMem #(
    parameter   ADDRESS_WIDTH = 32,
                DATA_WIDTH = 32
)(
    input  logic                       clk,
    input  logic                       reset,
    input  logic  [ADDRESS_WIDTH-1:0]  addr,
    output logic  [DATA_WIDTH-1:0]     instr
);

logic  [DATA_WIDTH-1:0] rom_array [2**ADDRESS_WIDTH-1:0];

initial begin
        $display("Loading rom.");
        $readmemh("Lab4.mem", rom_array);
end;

always_ff @(posedge clk, posedge reset)
begin
    // output is asynchronous
    instr <= rom_array [addr];
end

endmodule

