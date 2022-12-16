module Reg_file #(
    parameter ADDRESS_WIDTH = 5,
              DATA_WIDTH = 32
)(
    input   logic [ADDRESS_WIDTH-1:0]        AD1,
    input   logic [ADDRESS_WIDTH-1:0]        AD2,
    input   logic [ADDRESS_WIDTH-1:0]        AD3,
    input   logic                            WE3,
    input   logic [DATA_WIDTH-1:0]           WD3,
    input   logic                            clk,
    output  logic [DATA_WIDTH-1:0]           RD1,
    output  logic [DATA_WIDTH-1:0]           RD2,
    output  logic [DATA_WIDTH-1:0]           a0

);

    logic [DATA_WIDTH-1:0] reg_array [2**ADDRESS_WIDTH-1:0];

    always_ff @ (posedge clk) begin
        if (WE3)
            reg_array[AD3] <= WD3;
    end 

    assign reg_array[0]= 32'b0; 


    assign a0 = reg_array[{5'b01010}];

    always_comb
    begin
        RD1 = reg_array[AD1];
        RD2 = reg_array[AD2];
    end

     initial begin
        for (int i = 0; i < $size(reg_array); i++) begin
            reg_array[i] = 32'b0;
        end
    end
        
endmodule


