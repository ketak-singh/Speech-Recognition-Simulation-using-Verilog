module UART_TX #(parameter PARITY_BIT=0)(input wire CLK,RST,UART_CLK_EN,DATA_SEND,wire [7:0]DATA__IN, output reg BUSY,UART_TXD , reg [3:0]STATE );
    
 
    reg tx_clk_en ;
    reg tx_clk_divider_en;
    reg[3:0] tx_ticks;
    reg [7:0] tx_data;
    reg[2:0] tx_bit_count = 0;
    reg tx_bit_count_en ;
    reg tx_busy = 1;
    wire tx_parity_bit;
    reg[1:0] tx_data_out_sel;

    //type state is (idle(0), txsync(1), startbit(2), databits(3), paritybit(4), stopbit(5));
    integer tx_pstate = 0;
    integer tx_nstate;

begin
    always @ *
    begin
    BUSY <= tx_busy;
    end
  
    //-- UART TRANSMITTER CLOCK DIVIDER

	always @(posedge CLK)
    begin
        
            if (tx_clk_divider_en == 1)
            begin
                if (UART_CLK_EN == 1)
                begin
                    if (tx_ticks == 4'b1111)
                    begin
                        tx_ticks <= 4'b0000;
                        tx_clk_en <= 0;
                    end
                    else if (tx_ticks == 4'b0111)
                    begin
                        tx_ticks <= tx_ticks + 1;
                        tx_clk_en <= 1;
                    end
                    else
                    begin
                        tx_ticks <= tx_ticks + 1;
                        tx_clk_en <= 0;
                    end
                end
                    
                else
                begin
                    tx_ticks <= tx_ticks;
                    tx_clk_en <= 0;
                end
            end
            else
            begin
                tx_ticks <= 4'b0000;
                tx_clk_en <= 0;
           end                
    end

  
    //-- UART TRANSMITTER INPUT DATA REGISTER
 
	always @ (posedge CLK)
    begin
       
            if (RST == 1) 
            begin
                tx_data <= 8'b00000000;
            end
            else if (DATA_SEND == 1 && tx_busy == 0) 
            begin
                tx_data <= DATA__IN;
            end
    end


    //-- UART TRANSMITTER BIT COUNTER
  

always @ (posedge CLK)
    begin
            if (RST == 1)
            begin
                tx_bit_count <= 3'b000;
                end
            else if (tx_bit_count_en == 1 && tx_clk_en == 1)
            begin
                if (tx_bit_count == 3'b111)
                begin
                    tx_bit_count <= 3'b000;
                end
                else
                begin
                    tx_bit_count <= tx_bit_count + 1;
                end
           end
               
    end

   // -- UART TRANSMITTER PARITY GENERATOR
   
	if (PARITY_BIT != 0)
        begin

	UART_PARITY u0(.DATA_IN(DATA__IN),.PARITY_TYPE(PARITY_BIT),.PARITY_OUT(tx_parity_bit));       
        end
 

//always @ *
//begin
if (PARITY_BIT == 0)
	begin
        assign tx_parity_bit = 1'bZ;
    end
//end

   // -- UART TRANSMITTER OUTPUT DATA REGISTER
 
	always @ (posedge CLK)
    begin
        
            if (RST == 1)
                UART_TXD <= 1;
            else
            begin
                case (tx_data_out_sel)
                     2'b01:
                        UART_TXD <= 0;
                     2'b10:
                        UART_TXD <= tx_data[tx_bit_count];
                     2'b11:
                        UART_TXD <= tx_parity_bit;
                    default:
                        UART_TXD <= 1;
                endcase 
             end
           
    end
  
    //-- UART TRANSMITTER FSM
  

    //-- PRESENT STATE REGISTER
    always @ (posedge CLK)
    begin
        
            if (RST == 1)
                tx_pstate <= 0;
            else
                tx_pstate <= tx_nstate;
                STATE<=tx_pstate;
    end

    //-- NEXT STATE AND OUTPUTS LOGIC
    always @ (tx_pstate, DATA_SEND, tx_clk_en, tx_bit_count)
    begin
        case (tx_pstate)

           0:
           begin
                tx_busy <= 0;
                tx_data_out_sel <= 2'b00;
                tx_bit_count_en <=0;
                tx_clk_divider_en <= 0;

                if (DATA_SEND == 1)
                    tx_nstate <= 1;
                else
                    tx_nstate <= 0;
           end

            1:
            begin
                tx_busy <= 1;
                tx_data_out_sel <= 2'b00;
                tx_bit_count_en <= 0;
                tx_clk_divider_en <= 1;

                if (tx_clk_en == 1) 
                    tx_nstate <= 2;
                else
                    tx_nstate <= 1;
             
            end
           2:
           begin
                tx_busy <= 1;
                tx_data_out_sel <= 2'b01;
                tx_bit_count_en <= 0;
                tx_clk_divider_en <= 1;

                if (tx_clk_en == 1) 
                    tx_nstate <= 3;
                else
                    tx_nstate <= 2;
             
            end
          3:
          begin
                tx_busy <= 1;
                tx_data_out_sel <= 2'b10;
                tx_bit_count_en <= 1;
                tx_clk_divider_en <= 1;

                if ((tx_clk_en == 1)&&(tx_bit_count == 3'b111)) 
                begin
                    if (PARITY_BIT == 0)
                        tx_nstate <= 5;
                    else
                        tx_nstate <= 4;
                end
                else
                    tx_nstate <= 3;
          end

           4:
           begin
                tx_busy <= 1;
                tx_data_out_sel <= 2'b11;
                tx_bit_count_en <= 0;
                tx_clk_divider_en <= 1;

                if (tx_clk_en ==1) 
                    tx_nstate <= 5;
                else
                    tx_nstate <= 4;
               end

            5:
            begin
                tx_busy <= 0;
                tx_data_out_sel <= 2'b00;
                tx_bit_count_en <= 0;
                tx_clk_divider_en <= 1;

                if ((DATA_SEND == 1) && (tx_clk_en==1)) 
                    tx_nstate <= 1;
                else if (tx_clk_en == 1) 
                    tx_nstate <= 0;
                else
                    tx_nstate <= 5;
               end

            default:
            begin
                tx_busy <= 1;
                tx_data_out_sel <= 2'b00;
                tx_bit_count_en <= 0;
                tx_clk_divider_en <= 0;
                tx_nstate <= 0;
                end
        endcase
    end 
    end
    endmodule 

