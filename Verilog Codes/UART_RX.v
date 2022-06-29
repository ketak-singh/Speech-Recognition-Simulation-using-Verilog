module UART_RX #(parameter PARITY_BIT=0)(input wire CLK,RST,UART_CLK_EN, UART_RXD, output reg DATA_VLD,FRAME_ERROR,reg [7:0]DATA_OUT);
   

    reg rx_clk_en = 0;
    reg [3:0] rx_ticks;
    reg rx_clk_divider_en;
    reg [7:0] rx_data = 0;
    reg [2:0] rx_bit_count = 3'b000;
    reg rx_bit_count_en;
    reg rx_data_shreg_en;
    wire rx_parity_bit = 0;
    reg rx_parity_error = 0;
    reg rx_parity_check_en;
    reg rx_output_reg_en = 0;
    
   integer idle=0;
   integer startbit=1;
   integer databits=2;
   integer paritybit =3;
   integer stopbit=4;
    
   integer rx_pstate = 0;
   integer rx_nstate ;
    //-- -------------------------------------------------------------------------
    //-- UART RECEIVER CLOCK DIVIDER
    //-- -------------------------------------------------------------------------
always @(posedge CLK)
            if (rx_clk_divider_en == 1)
            begin
                if (UART_CLK_EN == 1)
                begin 
                    if (rx_ticks == 4'b1111)
                    begin
                        rx_ticks <= 4'b0000;
                        rx_clk_en <= 0;
                    end
                    else if (rx_ticks == 4'b0111)
                    begin
                        rx_ticks <= rx_ticks + 1;
                        rx_clk_en <= 1;
                    end    
                    else
                    begin
                        rx_ticks <= rx_ticks + 1;
                        rx_clk_en <= 0;
                    end
                end
                else
                begin
                    rx_ticks <= rx_ticks;
                    rx_clk_en <= 0;
                end
            end
            else
            begin
                rx_ticks <= 4'b0000;
                rx_clk_en <= 0;
            end
  //  -- -------------------------------------------------------------------------
  //  -- UART RECEIVER BIT COUNTER
  //  -- -------------------------------------------------------------------------
 
always @(posedge CLK)
    begin     
            if (RST ==1)
            begin
                rx_bit_count <= 3'b000;
            end
            else if(rx_bit_count_en ==1 && rx_clk_en ==1)
            begin
                if (rx_bit_count == 3'b111)
                begin
                 rx_bit_count <= 3'b000; 
                 end  
                else
                begin
                    rx_bit_count <= rx_bit_count + 1;
                end  
          end
    end
    //-- -------------------------------------------------------------------------
   // -- UART RECEIVER DATA SHIFT REGISTER
   // -- -------------------------------------------------------------------------
	always @(posedge CLK)
    begin
        
            if (RST ==1)
            begin
                rx_data <= 8'b00000000;
            end
            else if (rx_clk_en ==1 && rx_data_shreg_en ==1)
            begin
                rx_data <= {UART_RXD , rx_data[7:1]};
            end    
    end
    always @ *
    begin
        DATA_OUT <= rx_data;  
    end
  //  -- -------------------------------------------------------------------------
  //  -- UART RECEIVER PARITY GENERATOR AND CHECK
  //  -- -------------------------------------------------------------------------
 	if (PARITY_BIT != 0)
         begin
 	   UART_PARITY u0(.DATA_IN(rx_data),.PARITY_TYPE(PARITY_BIT),.PARITY_OUT(rx_parity_bit)); 
 	always @ (posedge CLK)
         begin
            
                 if (RST ==1) 
                 begin 
                     rx_parity_error <= 0;
                 end
                 else if (rx_parity_check_en == 1) 
                 begin
                     rx_parity_error <= rx_parity_bit^UART_RXD;
               end         
         end
 end

 always @ *
 begin
     if (PARITY_BIT == 0)
     begin
           rx_parity_error <= 0;
     end
 end
   

//    -- -------------------------------------------------------------------------
//    -- UART RECEIVER OUTPUT REGISTER
//    -- ------------------------------------------------------------------------- 
always @(posedge CLK)
    begin
        
            if (RST ==1)
            begin
                DATA_VLD <= 0;
                FRAME_ERROR <= 0;
            end
            else
            begin
                if (rx_output_reg_en ==1)
                begin
                    DATA_VLD <= ~ rx_parity_error & UART_RXD;
                    FRAME_ERROR <= (~UART_RXD)&(~DATA_VLD);
                end
                else
                begin
                    DATA_VLD <= 0;
                    FRAME_ERROR <= 0;
               end
        end
    
    end
   // -- -------------------------------------------------------------------------
   // -- UART RECEIVER FSM
   // -- -------------------------------------------------------------------------

   // -- PRESENT STATE REGISTER
    always@(posedge CLK)
    begin
        
            if (RST ==1)
            begin
                rx_pstate <= idle;
            end
            else
            begin
                rx_pstate <= rx_nstate;
            end
           
     
    end

    //-- NEXT STATE AND OUTPUTS LOGIC
    always @ (rx_pstate, UART_RXD, rx_clk_en, rx_bit_count)
    begin
        case(rx_pstate)

            idle:
            begin 
                rx_bit_count_en <= 0;
                rx_data_shreg_en <= 0;
                rx_parity_check_en <= 0;
                rx_clk_divider_en <= 0;
                

                if ((UART_RXD == 0))
                begin
                    rx_nstate <= startbit;
                end
                else
                begin
                    rx_nstate <= idle;
                end                
            end
            startbit:
            begin
                rx_clk_divider_en <= 1;
                rx_output_reg_en <= 0;
                rx_bit_count_en <= 0;
                rx_data_shreg_en <= 0;
                rx_parity_check_en <= 0;

                if (rx_clk_en == 1) 
                    rx_nstate <= databits;
                else
                    rx_nstate <= startbit;
             end 

            databits:
            begin
                rx_output_reg_en <= 0;
                rx_bit_count_en <= 1;
                rx_data_shreg_en <= 1;
                rx_clk_divider_en <= 1;
                rx_parity_check_en <= 0;

                if ((rx_clk_en ==1) && (rx_bit_count == 3'b111))
                begin
                    if (PARITY_BIT ==0)
                    begin
                        rx_nstate <= stopbit;
                    end
                    else
                    begin
                        rx_nstate <= paritybit; 
                    end   
                end           
                else
                begin
                    rx_nstate <= databits;
                end
         end

            paritybit:
            begin
                rx_output_reg_en <= 0;
                rx_bit_count_en <= 0;
                rx_data_shreg_en <= 0;
                rx_clk_divider_en <= 1;
                rx_parity_check_en <= 1;

                if (rx_clk_en == 1) 
                begin
                    rx_nstate <= stopbit;
               end
                else
                begin
                    rx_nstate <= paritybit;
                end
              end
            stopbit:
            begin
                rx_bit_count_en <= 0;
                rx_data_shreg_en <= 0;
                rx_clk_divider_en <= 1;
                rx_parity_check_en <= 0;

                if (rx_clk_en == 1)
                begin
                    rx_nstate <= idle;
                    rx_output_reg_en <= 1;
               end
                else
                begin
                    rx_nstate <= stopbit;
                    rx_output_reg_en <= 0;
               end
            end

            default:
            begin
                rx_output_reg_en <= 0;
                rx_bit_count_en <= 0;
                rx_data_shreg_en <= 0;
                rx_clk_divider_en <= 0;
                rx_parity_check_en <= 0;
                rx_nstate <=idle;
            end
        endcase
     end
endmodule