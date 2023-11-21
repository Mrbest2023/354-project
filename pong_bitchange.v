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
	input down1,
	input down2,
	input up2,
	input [9:0] hCount, vCount,
	input rst,
	output reg [11:0] rgb,
	output reg [15:0] score
	//output wire lp_collision
   );
	reg [9:0] ypos1, ypos2, xpos1, xpos2;
	parameter BLACK = 12'b0000_0000_0000;
	parameter WHITE = 12'b1111_1111_1111;
	parameter RED   = 12'b1111_0000_0000;
	parameter GREEN = 12'b0000_1111_0000;
	parameter BLUE = 12'b0000_0000_1111;

	wire midline;
	wire leftPaddle;
	wire rightPaddle; 
	reg[9:0] ballxvelocity, ballyvelocity, ballx, bally;
	reg reset;
	reg collision_flag;
	wire lp_collision, rp_collision, bw_collision, tw_collision;


	initial begin
		score = 15'd0;
		reset = 1'b0;
	end
	
	
	always@ (*) 
    	if (~bright)
		rgb = BLACK; // force black if not bright
	 else if (leftPaddle == 1)
		rgb = GREEN;
	 else if (rightPaddle == 1)
	    rgb = GREEN;
	else if ( ball == 1)
		rgb = RED;
	 else if (midline == 1)
		rgb = WHITE; // white box
	 else
		rgb = BLUE; // background color
	

//ball logic
always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			ballx <=463;
			bally <= 275;
			collision_flag <= 0;
			ballxvelocity <= -2;
			ballyvelocity <= 1;
			
		end
		else if (clk) 
			begin
				//left paddle collision event
			  if (lp_collision && collision_flag==0)
				  begin
				      collision_flag <= 1;
					  ballxvelocity <= ballxvelocity * -1;
					  ballx <= 10'd178;
				  end
			  else if (rp_collision && collision_flag== 0)
				  begin
				      collision_flag <= 1;
					  ballxvelocity <= ballxvelocity * -1;
					  ballx <= 10'd750;
				  end
			  else if (bw_collision && collision_flag== 0)
				  begin
				      collision_flag <= 1;
					  ballyvelocity <= ballyvelocity * -1;
					  bally <= 10'd504;
				  end
			  else if (tw_collision && collision_flag== 0)
				  begin
				      collision_flag <= 1;
					  ballyvelocity <= ballyvelocity * -1;
					  bally <= 10'd46;
				  end
			  else
					begin
					  collision_flag <= 0;
					  ballx <= ballx + ballxvelocity;
					  bally <= bally + ballyvelocity;
					end
			end
			
	end
		
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			ypos1<=250;
		end
		else if (clk) 
		begin
			if(button && ypos1 > 34) begin   //paddle 1 movement
				ypos1<=ypos1-2; //change the amount you increment to make the speed faster 
			end
			else if(down1 && ypos1 < 514) begin
				ypos1<=ypos1+2;
			end
		end
	end

	always@(posedge clk, posedge rst)
	begin
		if(rst)
		begin 
		ypos2 <= 250;
		end
		else if (clk)
		begin
			 if(up2 && ~down2 && ypos2 > 34) begin  //padde 2 movement
				ypos2<=ypos2-2;
			end
			else if(down2 && ~up2 && ypos2 < 516) begin
				ypos2<=ypos2+2;
			end
       
		end
	end	
	
	
	//drawing objects on the screen
	assign midline = ((hCount >= 10'd460) && (hCount <= 10'd466)) && ((vCount >= 10'd34) && (vCount <= 10'd516)) ? 1 : 0;

	assign ball = ((hCount >= ballx-10) && (hCount <= ballx+10)) && ((vCount >= bally-10) && (vCount <= bally+10)) ? 1 : 0;

	assign leftPaddle = ((hCount >= 10'd155) && (hCount <= 10'd165)) && ((vCount >= ypos1-30) && (vCount <= ypos1+30)) ? 1 : 0;
	
	assign rightPaddle =((hCount >= 10'd762) && (hCount <= 10'd772)) && ((vCount >= ypos2-30) && (vCount <= ypos2+30)) ? 1 : 0;
	
	
	
	//left paddle collision
	assign lp_collision = ( (ballx- 10) <= 165) &&  ((ballx- 10) >= 162) &&(bally <=ypos1+30) && (bally >= ypos1 - 30) ? 1 : 0 ;
	
	//right paddle collision
	assign rp_collision = ( (ballx+ 10) >= 762) && ((ballx+ 10) <= 765) && (bally <=ypos2+30) && (bally >= ypos2 - 30) ? 1 : 0 ;
	
	//bottom wall collision
	assign bw_collision = ( bally + 10 >= 516) ? 1 : 0 ;
	
	//top wall collision
	assign tw_collision = ( bally - 10 <= 34) ? 1 : 0 ;
	
	
endmodule
