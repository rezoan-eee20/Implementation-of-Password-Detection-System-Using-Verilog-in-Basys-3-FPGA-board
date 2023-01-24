`timescale 1ns / 1ps

module Main_FSM(
	input clk,
	input reset,
	input Ubtn, // UP button
	input Dbtn, // DOWN button
	input Lbtn, // LEFT button
	input Rbtn, // RIGHT Button
	output reg [6:0] SSG_D, // 7-bit seven segment display
	output [2:0] SSG_EN 	// disable 3 of 4, 7-segment LEDs; we only need 1
	);
    
	// need 4 bit for 9 parameters
	parameter IDLE = 4'b0000; 	// after pushing reset (CENTER) button
	parameter ST0 = 4'b0001; 	// after pushing UP button 
	parameter ST1 = 4'b0010; 	// after pushing LEFT button
	parameter ST2 = 4'b0011; 	// after pushing LEFT button
	parameter ST3 = 4'b0100; 	// after pushing RIGHT button
	parameter E1 = 4'b0101; 	// error if push nUe after IDLE state
	parameter E2 = 4'b0110; 	// any button after E1 or nLe button after Ue
	parameter E3 = 4'b0111; 	// any button after E2 or nLe button after Le
	parameter E4 = 4'b1000; 	// any button after E3 or nRe button after LLe
    
    reg [3:0] c_state ;		// Current state
	reg [3:0] n_state ;		// Next state 
	
	wire Ue, De, Le, Re;
	wire Uin, nUin, Lin, nLin, Rin, nRin, anyIN;
	
	assign Uin = Ue & !(De | Le | Re); // to check if multiple buttons are pushed at the same time 
	assign nUin = !Ue & (De | Le | Re);
	assign Lin = Le & !(Ue | De | Re);
	assign nLin = !Le & (Ue | De | Re);
	assign Rin = Re & !(Ue | De | Le);
	assign nRin = !Re & (Ue | De | Le);
	assign anyIN = Ue | De | Le | Re;
	
	// instantiate the small FSM here
	button_FSM Up_pushed (clk, reset, Ubtn, Ue);
	button_FSM Dn_pushed (clk, reset, Dbtn, De);
	button_FSM Lf_pushed (clk, reset, Lbtn, Le);
	button_FSM Rt_pushed (clk, reset, Rbtn, Re);
    
    // FSM for State Transition
	always @(posedge clk) // Synchronous 
	begin
	if (reset) c_state <= IDLE;
	else c_state <= n_state;
	end

	// logic to determine next state
	// FSM for all 4 buttons (U L L R)
	always @(*) 
	begin
	case (c_state)
	IDLE : if (Uin) n_state = ST0;
	       else if (nUin) n_state = E1;
	       else n_state = IDLE;
	ST0 : if (Lin) n_state = ST1;
	      else if (nLin) n_state = E2;
	      else n_state = ST0;
	ST1 : if (Lin) n_state = ST2;
	      else if (nLin) n_state = E3;
	      else n_state = ST1;
	ST2 : if (Rin) n_state = ST3;
	      else if (nRin) n_state = E4;
	      else n_state = ST2;
	ST3 : if (reset) n_state = IDLE;
	      else n_state = ST3;
	E1 : if (anyIN) n_state = E2;
	     else n_state = E1;
	E2 : if (anyIN) n_state = E3;
	     else n_state = E2;
	E3 : if (anyIN) n_state = E4;
	     else n_state = E3;
	E4 : if (reset) n_state = IDLE;
	     else n_state = E4;
	default : n_state = IDLE;
	endcase
	end
	
	// 7 segment display results when c_states are reached
	always @(*)
	begin
	case (c_state)
	IDLE : SSG_D = 7'b1000000;	// OUTPUT 0
	ST0 : SSG_D = 7'b1111001; 	// Output 1
	ST1 : SSG_D = 7'b0100100; 	// OUTPUT 2
	ST2 : SSG_D = 7'b0110000;	// OUTPUT 3
	ST3 : SSG_D = 7'b0010000; 	// OUTPUT 9  -	Correct Code Indication
	E1 : SSG_D = 7'b0011001; 	// OUTPUT 4
	E2 : SSG_D = 7'b0010010; 	// OUTPUT 5
	E3 : SSG_D = 7'b0000000; 	// OUTPUT 8
	E4 : SSG_D = 7'b0000110;
	default : SSG_D = 7'b1111111; // OFF
	endcase
	end
	
	assign SSG_EN = 3'b111; // disable the other 3 LEDs; We need only 1
	
endmodule