module Reg_file #(
    parameter ADDRESS_WIDTH = 32,
              DATA_WIDTH = 32
)(
    input   logic [ADDRESS_WIDTH-1:0]        AD1,
    input   logic [ADDRESS_WIDTH-1:0]        AD2,
    input   logic [ADDRESS_WIDTH-1:0]        AD3,
    input   logic                            WE3,
    input   logic [ADDRESS_WIDTH-1:0]        WD3,
    input   logic                            clk,
    output  logic [DATA_WIDTH-1:0]           RD1,
    output  logic [DATA_WIDTH-1:0]           RD2,
    output  logic [DATA_WIDTH-1:0]           a0

);

    logic [ADDRESS_WIDTH-1:0] reg_array [2**DATA_WIDTH-1:0];

    always_ff @ (posedge clk) 
        if (WE3 == 1'b1)
            reg_array[AD3] <= WD3;

    assign a0 = reg_array[5'b01010];

    assign    RD1 = reg_array[AD1];
    assign    RD2 = reg_array[AD2];
        
endmodule

