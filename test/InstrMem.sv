module InstrMem #(
    parameter ADDRESS_WIDTH = 32
) (
    input  logic [ADDRESS_WIDTH-1:0] addr,
    output logic [ADDRESS_WIDTH-1:0] instr
);

  logic [7:0] rom_array[(2**14)-1:0];

  initial begin
    $display("Loading rom.");
    $readmemh("InstrMem.mem", rom_array);
  end
  ;

  always_comb begin
    instr = {{rom_array[addr+0]}, {rom_array[addr+1]}, {rom_array[addr+2]}, {rom_array[addr+3]}};
  end
endmodule

