module uart_tx(
               input wire       clk,
               input wire       clr,
               input wire       ready,
               input wire [7:0] tx_data,
               output reg       txD,
               output reg       tdre);

   parameter bit_time = 16'h1458; //baud rate
   parameter idle = 3'b000, start = 3'b001, delay = 3'b010, shift = 3'b011 , stop = 3'b100; //Estados de la FSM

   reg [2:0]                    state;
   reg [7:0]                    bufftx;               //almacenar dato tx
   reg [15:0]                   baud_count;  //contador para delay
   reg [3:0]                    bit_count;    //contador bits transmitidos

   always @(posedge clk or posedge clr)
     begin
        if(clr ==1)
          begin
             state <= idle;
             bufftx <= 0;
             baud_count <= 0;
             bit_count <= 0;
             txD <= 1;
          end
        else
          begin
             case (state)
               idle:
                 begin
                    bit_count <= 0;
                    tdre  <= 0;
                    if (ready == 0)
                      begin
                         state <= idle;
                         bufftx <= tx_data;
                      end
                    else
                      begin
                         baud_count <= 0;
                         state <= start;
                      end
                 end
               start:
                 begin
                    baud_count <= 0;
                    txD <= 0;
                    tdre <= 0;
                    state <= delay;
                 end
               delay:
                 begin
                    tdre <= 0;
                    if (baud_count >= bit_time)
                      begin
                         baud_count <= 0;
                         if(bit_count < 8)
                           state <= shift;
                         else
                           state <= stop;
                      end
                    else
                      begin
                         baud_count <= baud_count +1;
                         state <= delay;
                      end
                 end
               shift:
                 begin
                    tdre <= 0;
                    txD <= bufftx[0];
                    bufftx[6:0] <= bufftx[7:0];
                    bit_count <= bit_count +1;
                    state <= delay;
                 end
               stop:
                 begin
                    tdre <= 1;
                    txD <= 1;
                    if(baud_count >= bit_time)
                      begin
                         baud_count <= 0;
                         state <= idle;
                      end
                    else
                      begin
                         baud_count <= baud_count+1;
                         state <= stop;
                      end
                 end
             endcase
          end
        endmodule
