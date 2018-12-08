module Bit_Input (values, in0,in1,in2,in3, loadButton, backspace, clear, rst, clk, testRST, testLoad, testBackspace, testClear, nEntered, S);
	output [63:0]values;
	output testRST, testLoad, testBackspace, testClear;
	input in0, in1, in2, in3, loadButton, backspace, clear, rst, clk;
	output [4:0] nEntered; // how many digits have been entered (0-16)
	output [3:0] S;
	reg [4:0] nEntered;
	reg [5:0] cursor;
	reg [63:0] values;
	
	
	// State machine implementation
	reg [3:0] S;
	parameter AWAITING_ENTRY = 4'b0000,
	ENTER_BITS = 4'b0001,
	CURSOR_FORWARD = 4'b0010,
	LOAD_BUTTON_HELD = 4'b0011,
	BITS_ENTERED = 4'b0100,
	SHOW_RESULT = 4'b0101,
	CLEAR = 4'b0110,
	CHECK_CURSOR = 4'b0111,
	CURSOR_BACK = 4'b1000,
	BACKSPACE_HELD = 4'b1001,
	ERROR = 4'b1010;
	
	reg [3:0] NS;
	
	
	assign testRST = rst;
	assign testLoad = !loadButton;
	assign testBackspace = !backspace;
	assign testClear = !clear;
	
	// user input is loaded by entering values on switches and then press load button
	
	always @ (posedge clk or negedge rst)
	begin
		if(rst == 1'b0)
		begin
			cursor <= 6'd63;
			values <= 64'b0000000100100011010001010110011110001001101010111100110111101111;
			nEntered <= 5'd0;
			S <= AWAITING_ENTRY;
		end
		else
		begin
			S <= NS;
			
			if (S == ENTER_BITS)
			begin
				values[cursor-:4] <= {in3, in2, in1, in0};
			end
			else if (S == CURSOR_FORWARD)
			begin
				cursor <= cursor-6'd4;
				nEntered <= nEntered + 5'd1;
			end
			else if (S == CLEAR)
			begin
				cursor <= 6'd63;
				nEntered <= 5'd0;
			end
			else if (S == CURSOR_BACK)
			begin
				cursor <= cursor + 6'd4;
				nEntered <= nEntered - 5'd1;
			end
			
		end
		
	end
	
	
	always @(*)
	begin
		case (S)
			AWAITING_ENTRY:
			begin
				if (!loadButton)
					NS = ENTER_BITS;
				else if (!backspace)
					NS = CHECK_CURSOR;
				else if (!clear)
					NS = CLEAR;
				else
					NS = AWAITING_ENTRY;
			end
			ENTER_BITS:
				NS = CURSOR_FORWARD;
			CURSOR_FORWARD:
				NS = LOAD_BUTTON_HELD;
			LOAD_BUTTON_HELD:
			begin
				if (!loadButton)
					NS = LOAD_BUTTON_HELD;
				else
					NS = BITS_ENTERED;
			end
			BITS_ENTERED:
			begin
				if (nEntered < 5'd16)
					NS = AWAITING_ENTRY;
				else
					NS = SHOW_RESULT;
			end
			SHOW_RESULT:
			begin
				if (!backspace)
					NS = CURSOR_BACK;
				else if (!clear)
					NS = AWAITING_ENTRY;
				else
					NS = SHOW_RESULT;
			end
			CLEAR:
				NS = AWAITING_ENTRY;
			CHECK_CURSOR:
			begin
				if (nEntered == 5'd0)
					NS = BACKSPACE_HELD;
				else
					NS = CURSOR_BACK;
			end
			CURSOR_BACK:
				NS = BACKSPACE_HELD;
			BACKSPACE_HELD:
			begin
				if (!backspace)
					NS = BACKSPACE_HELD;
				else
					NS = AWAITING_ENTRY;
			end
			default:
				NS = ERROR;
		endcase
	end
	
endmodule
	
		