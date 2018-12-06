module Bit_Input (values, in0,in1,in2,in3, loadButton, rst, clk, testRST, testLoad, nEntered);
	output [63:0]values;
	output testRST, testLoad;
	input in0, in1, in2, in3, loadButton, rst, clk;
	output [4:0] nEntered; // how many digits have been entered
	reg [4:0] nEntered;
	reg [5:0] cursor;
	reg [63:0] values;
	
	reg entered; // 1'b1 if a value has been entered since the last time the button was released
	
	
	assign testRST = rst;
	assign testLoad = loadButton;
	
	// user input is loaded by entering values on switches and then press load button
	
	always @ (posedge clk or negedge rst)
	begin
		if(rst == 1'b0)
		begin
			cursor <= 6'd63;
			values <= 64'd1;
			entered <= 1'b0;
			nEntered <= 5'd0;
		end
		
		else if (entered == 1'b0 && loadButton == 1'b0 && nEntered < 5'd16)
		begin
			values[cursor-:4] <= {in3,in2,in1,in0};
			
			cursor <= cursor-6'd4;
			nEntered <= nEntered + 5'd1;
			entered <= 1'b1;
			// set encryption into motion: need either 3, -1 or 64 probably as control value
		end
		else if (loadButton == 1'b1)
		begin
			entered <= 1'b0;
		
		end
	end
	
endmodule
	
		