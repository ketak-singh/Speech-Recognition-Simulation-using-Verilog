`timescale 1ns / 1ps

module UART_TX_UUT();

parameter PARITY_BIT=0;
reg CLK,RST,UART_CLK_EN,DATA_SEND;
reg [7:0]DATA__IN;
wire BUSY,UART_TXD;
wire [3:0] STATE;

UART_TX uut (.CLK(CLK),.RST(RST),.UART_CLK_EN(UART_CLK_EN),.UART_TXD(UART_TXD),.DATA__IN(DATA__IN),.DATA_SEND(DATA_SEND),.BUSY(BUSY),.STATE(STATE));
defparam uut.PARITY_BIT = PARITY_BIT;  
initial
begin
    CLK=0;
    RST=0;
    UART_CLK_EN=0;
    DATA_SEND=0;
    DATA__IN=8'b01011010;
end

always  
    #0.5 CLK = ~CLK;
always
    #1 UART_CLK_EN = ~UART_CLK_EN;

initial
begin   
    DATA_SEND=1;
    #320 DATA_SEND=0;
end

endmodule
