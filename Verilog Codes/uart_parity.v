module UART_PARITY #(parameter DATA_WIDTH=8)(input wire [DATA_WIDTH-1:0] DATA_IN , [31:0]PARITY_TYPE ,output reg PARITY_OUT);
    reg parity_temp = 0;
    integer i;
    always @(PARITY_TYPE)
        if(PARITY_TYPE==1)          //-- EVEN
        begin
            parity_temp=1'b0;
            for(i=0; i<DATA_WIDTH;i=i+1) 
                parity_temp = parity_temp ^ DATA_IN[i];
            PARITY_OUT <= parity_temp;
        end        
        else if(PARITY_TYPE==2)         //-- ODD
        begin
            parity_temp=1'b1;
            for(i=0; i<DATA_WIDTH;i=i+1) 
                parity_temp = parity_temp ^ DATA_IN[i];
            PARITY_OUT = parity_temp;
        end
        else if(PARITY_TYPE==3)         // --MARK
            PARITY_OUT = 1'b1;
        else if(PARITY_TYPE==4)         // --SPACE
            PARITY_OUT = 1'b0;
endmodule