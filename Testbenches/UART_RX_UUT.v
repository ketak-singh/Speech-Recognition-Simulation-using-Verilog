`timescale 1ns / 1ps

module UART_RX_UUT();

parameter PARITY_BIT=0;
reg CLK,RST,UART_CLK_EN, UART_RXD;
wire [7:0]DATA_OUT;
wire DATA_VLD,FRAME_ERROR;

UART_RX uut(.CLK(CLK),.RST(RST),.UART_CLK_EN(UART_CLK_EN),.UART_RXD(UART_RXD),.DATA_OUT(DATA_OUT),.DATA_VLD(DATA_VLD),.FRAME_ERROR(FRAME_ERROR));
defparam uut.PARITY_BIT = PARITY_BIT;

initial
begin
     {CLK,RST,UART_CLK_EN, UART_RXD}=0;
end

always  
    #0.5 CLK = ~CLK;
always
    #1 UART_CLK_EN = ~UART_CLK_EN;
initial begin    
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;

    #32 UART_RXD = 0;

    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    end


initial
#800 $finish;
endmodule
