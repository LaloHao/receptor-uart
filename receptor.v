module receptor
  #(parameter DATA_LENGHT = 8,  // Datos de 8 bits
    parameter DELAY_TIME = 1)   // 50Mhz/5208=9600.61443932bps
   (input wire                   RxD,
    input wire                   rdrf_clr, clk, reset,
    input wire [1:0]             parity,
    output reg [DATA_LENGHT-1:0] rx_data,
    output reg                   rdrf, FE);

   reg [1:0]                     currentState, nextState;

   localparam START = 0, READ = 1, CHECK = 2, DELAY = 3; // Estados

   reg [DATA_LENGHT+1:0]         rx_data_tmp;      // Registro temporal de datos
   reg                           done;             // Bandera de finalizacion de lectura de datos
   reg [14:0]                    clk_div, clk_out; // Divisor de frecuencia
   reg [3:0]                     cnt;              // Contador de para recibir datos y parity check
   reg                           checked;          // Bandera de finalizacion de parity check
   reg [4:0]                     ones;             // Cuenta cuantos '1' existen
   reg                           parity_error;     // Bandera que designa error en paridad

   always @(posedge clk, posedge reset)
     if (reset)       currentState <= START;
     else             currentState <= nextState;

   always @(posedge rdrf_clr)
     rdrf <= 0;

   always @(posedge clk)                     // Control de estados
     case (currentState)
       START:
         if (RxD)     nextState = START;
         else         nextState = DELAY;
       DELAY:
         if (clk_out) nextState = READ;
         else         nextState = DELAY;
       READ:
         if (done)    nextState = CHECK;
         else         nextState = DELAY;
       CHECK:
         if (checked) nextState = START;
         else         nextState = CHECK;
     endcase // case (currentState)

   always @(currentState)                     // Flujo de datos
     case (currentState)
       START:
         begin
            {rx_data, rdrf, FE, ones} = 0;    // Poner senhales internas en cero
            {cnt, done, checked} = 0;         // Poner banderas en cero
            {clk_out, clk_div} = 0;           // Poner el divisor de frecuencia en cero
            parity_error = 0;
         end
       DELAY:
         begin
            clk_div = clk_div + 1;            // Divisor de frecuencia
            if (clk_div >= DELAY_TIME - 1)
              clk_out = 1;
         end
       READ:
         begin
            {clk_out, clk_div} = 0;           // Poner el divisor de frecuencia en cero
            rx_data_tmp[cnt] = RxD;           // Guardar dato

            cnt = cnt + 1;
            if (cnt > DATA_LENGHT + 1)
              begin
                 done = 1;
                 rdrf = 1;
                 cnt = 0;
                 rx_data = rx_data_tmp[7:0]; // Mover datos recibidos al registro Rx
                 if (~rx_data_tmp[9])        // Chequeo de stop bit
                   FE = 1;
              end
         end
       CHECK:
         begin
            ones = ones + rx_data[cnt];
            cnt = cnt + 1;
            if (cnt > DATA_LENGHT)
              begin
                 checked = 1;
                 if (parity == 2'b00 || parity == 2'b11) // No parity
                   parity_error = 0;
                 else if (parity == 2'b01)               // Even parity
                   parity_error = rx_data_tmp[DATA_LENGHT] == (ones % 2);
                 else                                    // Odd parity
                   parity_error = rx_data_tmp[DATA_LENGHT] == ~(ones % 2);
              end
         end
     endcase // case (currentState)

endmodule // receptor
