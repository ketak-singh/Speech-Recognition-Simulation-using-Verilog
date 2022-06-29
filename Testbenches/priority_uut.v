`timescale 1ns / 1ps
module priority_uut;

parameter DATA_WIDTH=8;
reg [DATA_WIDTH-1:0] DATA_IN;
reg [31:0] PARITY_TYPE;
wire PARITY_OUT;

UART_PARITY uut(DATA_IN,PARITY_TYPE,PARITY_OUT);
integer i=1;
initial
begin
    for(i=0;i<=4;i=i+1)
        begin
            PARITY_TYPE=i;
            DATA_IN=8'b01001000;
            #10;
        end 
        $finish;
end
endmodule
