`timescale 1ns / 10ps

module Test_Bench;

	reg clk, reset, Ubtn, Dbtn, Lbtn, Rbtn;    // declare all inputs as register
	wire [6:0] SSG_D;                          // declare all outputs as wire
	wire [2:0] SSG_EN;

	parameter half_cycle = 10; // timescale = 1ns; Half_Cycle = 10 * timescale = 10 * 1ns = 10ns
	
	parameter period = 40;		// duration for each bit (periode) = 40 * timescale = 40 * 1ns  = 40ns
	
	// instantiate the verilog code with secret code here
	code_FSM Task2 (clk, reset, Ubtn, Dbtn, Lbtn, Rbtn, SSG_D, SSG_EN);
	
	initial 
	   begin
	       clk = 1'b0;
	       Ubtn = 1'b0;
	       Dbtn = 1'b0;
	       Lbtn = 1'b0;
	       Rbtn = 1'b0;
	   end
	
	always 
	   #half_cycle clk = !clk;  // clock generator

	initial
	   begin
	   
        reset = 1'b1;       // reset
        #100;                // wait for 100ns
        reset = 1'b0;
        #100;
        
        Ubtn = 1'b1;        // U_pushed
        #period;            // wait for period
        Ubtn = 1'b0;        
        #period;            // wait for period
        
        Lbtn = 1'b1;        // L_pushed
        #period;            // wait for period
        Lbtn = 1'b0;        
        #period;            // wait for period
        
        Lbtn = 1'b1;        // L_pushed
        #period;            // wait for period
        Lbtn = 1'b0;    
        #period;            // wait for period
        
        Rbtn = 1'b1;        // R_pushed
        #period;            // wait for period
        Rbtn = 1'b0; 	
        #period;            // wait for period
        //Should display 9 as correct code indication
        
        #period;            // wait for period
        Ubtn = 1'b1;        // U_pushed
        #period;            // wait for period
        Ubtn = 1'b0;	
        #period;            // wait for period
        //Should stay on 9
        
        #period;            // wait for period
        
        reset = 1'b1;       // reset
        #period;            // wait for period
        reset = 1'b0;       // set
        #period;            // wait for period
        
        Ubtn = 1'b1;        // U_pushed
        #period;            // wait for period
        Ubtn = 1'b0;    
        #period;            // wait for period
        
        Dbtn = 1'b1;        // D_pushed
        #period;            // wait for period
        Dbtn = 1'b0;    
        #period;            // wait for period
        
        Lbtn = 1'b1;        // L_pushed
        #period;            // wait for period
        Lbtn = 1'b0;    
        #period;            // wait for period
        
        Rbtn = 1'b1;        // R_pushed
        #period;            // wait for period
        Rbtn = 1'b0; 	
        #period;            // wait for period
        //Should display E as incorrect code indication
        
        #period;            // wait for period
        Lbtn = 1'b1;        // L_pushed
        #period;            // wait for period
        Lbtn = 1'b0; 
        #period;            // wait for period
        //Should stay on E
        
        #period;            // wait for period
        
        reset = 1'b1;       // reset
        #period;            // wait for period
        
        #100;
        $finish;              // end of simulation
	   end
endmodule