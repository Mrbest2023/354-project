`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:15:38 12/14/2017 
// Design Name: 
// Module Name:    vgaBitChange 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
// Date: 04/04/2020
// Author: Yue (Julien) Niu
// Description: Port from NEXYS3 to NEXYS4
//////////////////////////////////////////////////////////////////////////////////
module vga_bitchange(
	input clk,
	input bright,
	input button,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [15:0] score
   );
	
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;

	wire midline;
	wire leftPaddle;
	//wire rightPaddle; //wait for when we make player 2 mode
	reg reset;


	initial begin
		score = 15'd0;
		reset = 1'b0;
	end
	
	
	always@ (*) 
    	if (~bright)
		rgb = BLACK; // force black if not bright
	 else if (leftPaddle == 1)
		rgb = GREEN;
	 else if (midline == 1)
		rgb = WHITE; // white box
	 else
		rgb = BLUE; // background color

	


	assign midline = ((hCount >= 10'd318) && (hCount <= 10'd322)) && ((vCount >= 10'd34) && (vCount <= 10'd516)) ? 1 : 0;

	assign leftPaddle = ((hCount >= 10'd150) && (hCount <= 10'd170)) && ((vCount >= 10'd220) && (vCount <= 10'd260)) ? 1 : 0;
	
endmodule
