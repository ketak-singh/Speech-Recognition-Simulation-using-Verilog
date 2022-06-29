`timescale 1ns / 1ps

module UART_UUT();

parameter CLK_FREQ=3684e3;
parameter BAUD_RATE=115200;
parameter PARITY_BIT=0;
reg CLK,RST,UART_RXD,DATA_SEND; 
reg [7:0]DATA_IN;

wire UART_TXD,BUSY,DATA_VLD,FRAME_ERROR;
wire [7:0]DATA_OUT;

UART uut(.CLK(CLK),.RST(RST),.UART_RXD(UART_RXD),.DATA_SEND(DATA_SEND),.DATA_IN(DATA_IN),.UART_TXD(UART_TXD),.DATA_VLD(DATA_VLD),.FRAME_ERROR(FRAME_ERROR),.BUSY(BUSY),.DATA_OUT(DATA_OUT));
defparam uut.PARITY_BIT = PARITY_BIT;
defparam uut.CLK_FREQ = CLK_FREQ;
defparam uut.BAUD_RATE = BAUD_RATE;
initial begin
    {CLK,RST,UART_RXD,DATA_SEND} = 0;
    DATA_IN=8'b00110011;
end

always
#0.5 CLK=~CLK;

initial
begin   
    DATA_SEND=1;
    #320 DATA_SEND=0;
end

initial begin  
    #320  
    #32 UART_RXD = 0;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 RST=1;
end

endmodule
