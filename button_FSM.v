`timescale 1ns / 1ps

module button_FSM(
    input clk,
    input reset,
    input button,
	output button_pushed
    );
    
    parameter   IDLE    =   2'b00;
    parameter   ST0     =   2'b01;
    parameter   ST1     =   2'b11;
    
    reg   [1:0]     c_state ;
    reg   [1:0]     n_state ;
	
// The following describes an FSM that detect a button is pushed and released. 
// After the detection of such events, the FSM output becomes 1 for one clock cycle
// The FSM output is used as the button pushed event signal
 
 //logic to determine next state - to detect the falling edge of the push button 
    always@(*)begin
    case(c_state)
    IDLE:   if(button == 1'b1)
            n_state = ST0;
            else 
            n_state = IDLE;
    ST0:    if(button == 1'b0)
            n_state = ST1;
            else 
            n_state = ST0;
    ST1:    n_state = IDLE;   //output state
			//button_pushed = 1'b1;
    default: n_state = IDLE;      
    endcase
    end
    
  //update state registers - // FSM for State Transition
    always@(posedge clk or posedge reset)
    if(reset) c_state  <=  IDLE;
    else c_state <=  n_state;
 
  // FSM output
  assign  button_pushed = (c_state == ST1)? 1'b1  : 1'b0;  
  
endmodule
