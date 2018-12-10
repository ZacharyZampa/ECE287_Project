/////////////////////////////////////////////////////////////////////////////////////
//																											  //
//			Base keyboard driver. It works.														  //
//			WASD, space bar and enter are already implmented.								  //
//			If you want to implement more keys, please look at the ps2 key codes.	  //
//			(Picture in the root of the repository)											  //
//																											  //
//			You can have a look at the pin assignments in our example project.        //
//			                                            										  //        
//---------------------------------------------------------------------------------//
//			Don't ever bother asking for help. (We are VERYY mean) (Just kidding)     //
//			You can mail us if you have any questions (cabrera@miamioh.edu) 			  //
//			or ask as in a lab				 														  //			
//																											  //
/////////////////////////////////////////////////////////////////////////////////////



module ps2Keyboard(CLOCK,ps2ck,ps2dt,numbers,keyBackspace,delete);

	inout ps2ck,ps2dt;	
	
	output [15:0]numbers;
	output keyBackspace,delete;
	reg [15:0]numbers;
	reg keyBackspace, delete;
	
	input CLOCK;
	
	reg releasex;
	reg releaseCK;
	
	reg [3:0]position;
	reg [5:0]skipCycles;	
	
	reg [2:0]e0;
	

	
	reg [55:0]nonActivity; //On a timeout, the data bytes reset.
	
	wire	[7:0]ps2_data;
	reg	[7:0]last_ps2_data;
	wire	ps2_newData;
	
	mouse_Inner_controller innerMouse (   //Don't touch anything in this declaration. It deals with the data adquisition and basic commands to the mouse.
	.CLOCK_50				(CLOCK),
	.reset				(1'b0),
	.PS2_CLK			(ps2ck),
 	.PS2_DAT			(ps2dt),
	.received_data		(ps2_data),
	.received_data_en	(ps2_newData)
	);
	

	always @(posedge ps2_newData)
	begin

			
				case (ps2_data)
					8'hF0: 
					begin //releasex will be 1 when the key has been released.
						releasex=1'b1;
						releaseCK=1'b0;		
					end
					8'hE0:
					begin
						e0=3'd3;
					end
				endcase
				
				
				
				if(e0<=0) //Certain keys have a pre-code
				begin
					case (ps2_data)						
						8'h45: numbers[0]<=!releasex;  // 0
						8'h16: numbers[1]<=!releasex;
						8'h1E: numbers[2]<=!releasex;
						8'h26: numbers[3]<=!releasex;
						8'h25: numbers[4]<=!releasex;
						8'h2E: numbers[5]<=!releasex;
						8'h36: numbers[6]<=!releasex;
						8'h3D: numbers[7]<=!releasex;
						8'h3E: numbers[8]<=!releasex;
						8'h46: numbers[9]<=!releasex;  // 9
						8'h1C: numbers[10]<=!releasex; // a
						8'h32: numbers[11]<=!releasex;
						8'h21: numbers[12]<=!releasex;
						8'h23: numbers[13]<=!releasex; // d
						8'h24: numbers[14]<=!releasex;
						8'h2B: numbers[15]<=!releasex;
						8'h66: keyBackspace<=!releasex;
					endcase
				end
				else if(e0>0)
					if (ps2_data == 8'h71)
						delete<=!releasex; // delete removes all input
						
				
			
			
			
			if(releaseCK==1'b1)
			begin
				releasex=0;
				releaseCK=0;
			end
			else
			begin
				if(releasex==1'b1)
				begin
					releaseCK=1'b1;
				end
			end
			
			if(e0>3'b0)
			begin
				e0=e0-3'b1;			
			end
			
			
		
		
		
		
		
	end

	
	endmodule
