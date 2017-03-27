module receptor_Uart;

	// Inputs
	reg RxD;
	reg rdrf_clr;
	reg clk;
	reg reset;
	reg [1:0] parity;

	// Outputs
	wire [7:0] rx_data;
	wire rdrf;
	wire FE;

	// Instantiate the Unit Under Test (UUT)
	receptor uut (
		.RxD(RxD),
		.rdrf_clr(rdrf_clr),
		.clk(clk),
		.reset(reset),
		.parity(parity),
		.rx_data(rx_data),
		.rdrf(rdrf),
		.FE(FE)
	);

	initial begin
		// Initialize Inputs
		RxD = 1;
		rdrf_clr = 0;
		clk = 0;             //RESET y RXD en '1' inicio
		reset = 1;
		parity = 0;

		#50;
			RxD = 1;
		rdrf_clr = 0;
		clk = 0;     //reset y rxd en '1'
		reset = 1;
		parity = 0;

		#50;

		  	RxD = 1;
		rdrf_clr = 0;
		clk = 0;         //reset =0 , entonces toma estado next_state pero sigue Rxd en reposo
		reset = 0;
		parity = 0;

		#50;
      RxD = 1;
		rdrf_clr = 0;
		clk = 0;    //reset =0 , entonces toma estado next_state pero sigue Rxd en reposo
		reset = 0;
		parity = 0;

		#50;

		  	RxD = 0;
		rdrf_clr = 0;  //toma estado next_state a delay (ya dio el bit de inicio)
		clk = 0;
		reset = 0;
		parity = 0;

		#50;
		RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 1 )
		clk = 0;
		reset = 0;
		parity = 0;

		#50;
		RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 2 )
		clk = 0;
		reset = 0;
		parity = 0;

		#50;

		RxD = 0;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 3 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

		RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 4 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

		RxD = 0;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 5 )
		clk = 0;
		reset = 0;
		parity = 0;

		#50;
		RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 6 )
		clk = 0;
		reset = 0;
		parity = 0;

		#50;

		RxD = 0;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 7 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

		RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 8 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

			RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 7 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

			RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 7 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

			RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 7 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;

			RxD = 1;
		rdrf_clr = 0;    //despues de delay, empieza READ, leer bit por bit hasta 8 (este es el 7 )
		clk = 0;
		reset = 0;
		parity = 0;
		#50;


	end
always
begin
	#2 clk=~clk; //bucle para pulsos clk
	end
endmodule
