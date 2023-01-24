`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2017 04:21:35 PM
// Design Name: 
// Module Name: lab
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab(
    input clk,
    input reset,
    input countup,
    output [6:0] SSG_D,
    output [2:0] SSG_EN  //disable three of four
    );
    
    parameter   IDLE    =   2'b00   ;
    parameter   ST0     =   2'b01   ;
    parameter   ST1     =   2'b11   ;
    
    reg   [1:0]     c_state ;
    reg   [1:0]     n_state ;
    reg   [3:0]       count   ;
    reg   [6:0]     SSG_D   ;
    
    wire cnt_enable;	
	
// The following describes an FSM that detect a button is pushed and released. 
// After the detection of such events, the FSM output becomes 1 for one clock cycle
// The FSM output is used as the counter enable signal
 
 //logic to determine next state
    always@(*)begin
    case(c_state)
    IDLE:   if(countup == 1'b1)
            n_state = ST0   ;
            else 
            n_state = IDLE   ;
    ST0:    if(countup == 1'b0)
            n_state = ST1   ;
            else 
            n_state = ST0   ;
    ST1:    n_state = IDLE  ;   //output state
    default: n_state = IDLE ;      
    endcase
    end
    
  //update state registers 
    always@(posedge clk or posedge reset)
    if(reset)
         c_state  <=  IDLE    ;
    else 
         c_state <=  n_state ;
 
  // FSM output
  assign  cnt_enable = (c_state == ST1)? 1'b1  : 1'b0;  
 
 
// 4 bit counting up counter with asynchronous reset and counting enable 
// Since the FSM output is generated shortly after the rising edge of the clock,
// the counter is design to be negative edge triggered to reduce the chances of
// having timing violations  

  always@(negedge clk or posedge reset)begin
  if(reset)
    count   <=  4'b0000;
   else if(cnt_enable) begin
        if(count == 4'b1001)
        count <=    4'b0000;
        else 
        count   <=  count + 1'b1;
   end     
   end

// send the counter output to 7 segment LED for display.   
  always@(*)begin                // decoder circuit for 7 segment LED
   case(count)
   4'b0000: SSG_D = 7'b1000000; //0
   4'b0001: SSG_D = 7'b1111001; //1
   4'b0010: SSG_D = 7'b0100100; //2
   4'b0011: SSG_D = 7'b0110000; //3 
   4'b0100: SSG_D = 7'b0011001; //4
   4'b0101: SSG_D = 7'b0010010; //5
   4'b0110: SSG_D = 7'b0000010; //6
   4'b0111: SSG_D = 7'b1111000; //7
   4'b1000: SSG_D = 7'b0000000; //8
   4'b1001: SSG_D = 7'b0010000; //9
   default: SSG_D = 7'b1111111; //none
   endcase
  end 
    
  assign        SSG_EN  =   3'b111;   // disable the other three LEDs
  
endmodule
