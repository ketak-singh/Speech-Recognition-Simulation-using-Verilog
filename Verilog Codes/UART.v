module UART #(parameter CLK_FREQ=3684e3,parameter BAUD_RATE=115200,parameter PARITY_BIT=0)(input wire CLK,RST,UART_RXD,[7:0]DATA_IN,DATA_SEND,output wire UART_TXD,BUSY,DATA_VLD,FRAME_ERROR, wire [7:0]DATA_OUT);
   
      // --comment PARITY_BIT  : string  := "none"  -- legal values: "none", "even", "odd", "mark", "space"
   
    integer divider_value = CLK_FREQ/(16*BAUD_RATE);

    integer uart_ticks=0;
    reg uart_clk_en =0;
    reg [3:0] uart_rxd_shreg =4'b1111;
    reg uart_rxd_debounced =1;

   // -- -------------------------------------------------------------------------
   // -- UART OVERSAMPLING CLOCK DIVIDER
   // -- -------------------------------------------------------------------------

begin:    uart_oversampling_clk_divider
always @ (posedge CLK)
    begin
        
            if (RST == 1) 
            begin
                uart_ticks <= 0;
                uart_clk_en <= 0;
            end
            else if (uart_ticks == divider_value-1)
            begin
                uart_ticks <= 0;
                uart_clk_en <= 1;
            end
            else
            begin
                uart_ticks <= uart_ticks + 1;
                uart_clk_en <= 0;
            end
    end
end: uart_oversampling_clk_divider
   // -- -------------------------------------------------------------------------
   // -- UART RXD DEBAUNCER
   // -- -------------------------------------------------------------------------

begin:  uart_rxd_debouncer 
always @ (posedge CLK)
    begin
        
            if (RST ==1) 
            begin
                uart_rxd_shreg <= 4'b1111;
                uart_rxd_debounced <= 1;
            end
            else
            begin
                uart_rxd_shreg <= UART_RXD & uart_rxd_shreg;
                uart_rxd_debounced <= uart_rxd_shreg[0] |
                                      uart_rxd_shreg[1] |
                                      uart_rxd_shreg[2] |
                                      uart_rxd_shreg[3];
           end
         
    end
end: uart_rxd_debouncer 
    //-- -------------------------------------------------------------------------
    //-- UART TRANSMITTER
    //-- -------------------------------------------------------------------------

begin  : uart_tx_i 
UART_TX#(.PARITY_BIT(PARITY_BIT)) uo (.CLK(CLK),.RST(RST),.UART_CLK_EN(uart_clk_en),.UART_TXD(UART_TXD),.DATA__IN(DATA_IN),.DATA_SEND(DATA_SEND),.BUSY(BUSY));
    
    
end: uart_tx_i
   // -- -------------------------------------------------------------------------
   // -- UART RECEIVER
   // -- -------------------------------------------------------------------------

begin:  uart_rx_i
UART_RX #(.PARITY_BIT(PARITY_BIT)) u1 (.CLK(CLK),.RST(RST),.UART_CLK_EN(uart_clk_en),.UART_RXD(UART_RXD),.DATA_OUT(DATA_OUT),.DATA_VLD(DATA_VLD),.FRAME_ERROR(FRAME_ERROR));
    
end: uart_rx_i
endmodule 