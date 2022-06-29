`timescale 1ns / 1ps
module VOICE_UUT();

parameter CLK_FREQ=3684e3;
parameter BAUD_RATE=115200;
parameter PARITY_BIT=0;
reg CLK,RST_N,UART_RXD,send;

wire UART_TXD,FRAME_ERR,BUSY;
wire [31:0] STATE;
wire [6:0] result;
reg VLD;

integer S_1;

reg [7:0] sample [15:0];
reg [7:0] qw;

Voice_recognition uut(.VLD(VLD),.STATE(STATE),.send(send),.CLK(CLK),.RST_N(RST_N),.UART_RXD(UART_RXD),.UART_TXD(UART_TXD),.FRAME_ERR(FRAME_ERR),.BUSY(BUSY),.result(result));
defparam uut.CLK_FREQ = CLK_FREQ;
defparam uut.BAUD_RATE = BAUD_RATE;
defparam uut.PARITY_BIT = PARITY_BIT;

initial
begin
    {RST_N,CLK,send,VLD}=0;
    UART_RXD=1;
end
always
#0.5 CLK=~CLK;

initial
begin
#323 VLD=1;
#1 VLD=0;
#609 VLD=1;
#1 VLD=0;
end
/*
initial begin  
    #01 RST_N=1;
    #02 RST_N=0;
    
//    send=1;
//    #320 send=0;
    
    #32 UART_RXD = 0;
    
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    
    send=1;
    #320 send=0;
    UART_RXD = 0;

    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    #32 UART_RXD = 0;
    #32 UART_RXD = 1;
    
    send=1;
    #320 send=0;
    end
*/

initial begin  
    #01 RST_N=1;
    #02 RST_N=0;
    S_1 = $fopen("C:\\Users\\adima\\Desktop\\nine.txt","r");

//    send=1;
//    #320 send=0;
    
    #32 UART_RXD = 0;
    $fscanf(S_1,"%b",qw);
    #32 UART_RXD = qw[0];
    #32 UART_RXD = qw[1];
    #32 UART_RXD = qw[2];
    #32 UART_RXD = qw[3];
    #32 UART_RXD = qw[4];
    #32 UART_RXD = qw[5];
    #32 UART_RXD = qw[5];
    #32 UART_RXD = qw[7];
    #32 UART_RXD = 1;
    
    send=1;
    #320 send=0;
    UART_RXD = 0;

    $fscanf(S_1,"%b",qw);
    #32 UART_RXD = qw[0];
    #32 UART_RXD = qw[1];
    #32 UART_RXD = qw[2];
    #32 UART_RXD = qw[3];
    #32 UART_RXD = qw[4];
    #32 UART_RXD = qw[5];
    #32 UART_RXD = qw[6];
    #32 UART_RXD = qw[7];
    #32 UART_RXD = 1;
    
    send=1;
    #320 send=0;
    end
 
endmodule
