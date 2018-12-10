module Bit_Input (values, in0,in1,in2,in3, loadButton, backspace, clear, rst, clk, testRST, testLoad, testBackspace, testClear, ps2ck, ps2dt, nEntered, S, screenRST);
	output [63:0]values;
	output testRST, testLoad, testBackspace, testClear;
	input in0, in1, in2, in3, loadButton, backspace, clear, rst, clk;
	input ps2ck,ps2dt;
	output [4:0] nEntered; // how many digits have been entered (0-16)
	output [3:0] S;
	output screenRST;
	reg [4:0] nEntered;
	reg [5:0] cursor;
	reg [63:0] values;
	
	
	// invoke keyboard input
	ps2Keyboard keyInput(clk,ps2ck,ps2dt,numbers,keyBackspace,delete);
	wire [15:0]numbers;
	wire keyBackspace, delete;
	
	
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
	ERROR = 4'b1010,
	TRANSLATE = 4'b1011;
	
	reg [3:0] NS;
	
	
	assign testRST = rst;
	assign testLoad = !loadButton;
	assign testBackspace = !backspace;
	assign testClear = !clear;
	
	assign screenRST = loadButton & backspace & clear & rst & !keyBackspace & !delete & numbers == 16'd0;
	
	// user input is loaded by entering values on switches and then press load button
	
	always @ (posedge clk or negedge rst)
	begin
		if(rst == 1'b0)
		begin
			cursor <= 6'd63;
			values <= 64'd0;
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
			else if (S == TRANSLATE)
			begin
				case(numbers)
					16'b0000000000000001: values[cursor-:4] = 4'd0;
					16'b0000000000000010: values[cursor-:4] = 4'd1;
					16'b0000000000000100: values[cursor-:4] = 4'd2;
					16'b0000000000001000: values[cursor-:4] = 4'd3;
					16'b0000000000010000: values[cursor-:4] = 4'd4;
					16'b0000000000100000: values[cursor-:4] = 4'd5;
					16'b0000000001000000: values[cursor-:4] = 4'd6;
					16'b0000000010000000: values[cursor-:4] = 4'd7;
					16'b0000000100000000: values[cursor-:4] = 4'd8;
					16'b0000001000000000: values[cursor-:4] = 4'd9;
					16'b0000010000000000: values[cursor-:4] = 4'd10;
					16'b0000100000000000: values[cursor-:4] = 4'd11;
					16'b0001000000000000: values[cursor-:4] = 4'd12;
					16'b0010000000000000: values[cursor-:4] = 4'd13;
					16'b0100000000000000: values[cursor-:4] = 4'd14;
					16'b1000000000000000: values[cursor-:4] = 4'd15;
				endcase
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
				else if (!backspace || keyBackspace) // when backspace is pressed
					NS = CHECK_CURSOR;
				else if (!clear || delete)
					NS = CLEAR;
				else if (numbers != 16'b0)
					NS = TRANSLATE;
				else
					NS = AWAITING_ENTRY;
			end
			ENTER_BITS:
				NS = CURSOR_FORWARD;
			CURSOR_FORWARD:
				NS = LOAD_BUTTON_HELD;
			LOAD_BUTTON_HELD:
			begin
				if (!loadButton || numbers != 16'b0)
					NS = LOAD_BUTTON_HELD;
				else
					NS = BITS_ENTERED;
			end
			BITS_ENTERED:
			begin
				if (nEntered != 5'd16)
					NS = AWAITING_ENTRY;
				else
					NS = SHOW_RESULT;
			end
			SHOW_RESULT:
			begin
				if (!backspace)
					NS = CURSOR_BACK;
				else if (!clear || delete)
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
				if (!backspace || keyBackspace)
					NS = BACKSPACE_HELD;
				else
					NS = AWAITING_ENTRY;
			end
			TRANSLATE:
				NS = CURSOR_FORWARD;
			default:
				NS = ERROR;
		endcase
	end
	
endmodule
	
		