module ECE287_Project(
  input in0, in1, in2, in3, loadButton, backspaceButton, clearButton, rst,
  output testRST, testLoad, testBackspace, testClear,
	//    LCD Module 16X2
  output LCD_ON,    // LCD Power ON/OFF
  output LCD_BLON,    // LCD Back Light ON/OFF
  output LCD_RW,    // LCD Read/Write Select, 0 = Write, 1 = Read
  output LCD_EN,    // LCD Enable
  output LCD_RS,    // LCD Command/Data Select, 0 = Command, 1 = Data
  inout [7:0] LCD_DATA,    // LCD Data bus 8 bits
  input CLOCK_50,
  input decrypt,
  input ps2ck,ps2dt, // keyboard clocks
  output [3:0] S // test output
	);

	assign    LCD_ON   = 1'b1;
	assign    LCD_BLON = 1'b1;
	
	
	
	// -------------------Instantiate Bit_Input Module----------------------
	wire [63:0] values;
	wire [4:0] nEntered;
	wire screenRST;
	Bit_Input bits(values[63:0], in0,in1,in2,in3, !loadButton, !backspaceButton, !clearButton, rst, CLOCK_50, testRST, testLoad, testBackspace, testClear, ps2ck, ps2dt, nEntered, S, screenRST);
	
	// -------------------Instantiate Module with the DES algorithm itself------
	wire [63:0] outValues;
	
	parameter key1 = 64'h133457799BBCDFF1, key2 = 64'h0000000000000000;
	//Triple_DES triDES(values, key1, key2, outValues, decrypt);
	DES_Encrypter(values, key1, outValues, decrypt);
	
	// -------------------Instantiate Bit_Converter Module----------------------
	wire [143:0] realLetter;
	wire [143:0] outHexChars;
	
	generate // generate 16 bit converter modules through for loop
		genvar ii;
		for(ii = 0; ii < 16; ii = ii+1) begin : generate_block_identifier
			Bit_Converter bits(realLetter[143-9*ii -: 9], values[63-4*ii -:4], nEntered > ii); // make each hex value accessible to LCD

			Bit_Converter outBits(outHexChars[143-9*ii -: 9], outValues[63-4*ii -:4], nEntered >= 5'd16);
		end
	endgenerate
	
	

	LCD_Display u1(
	// Host Side
		.iCLK(CLOCK_50),
		.iRST_N(screenRST),
		.realLetter(realLetter),
		.outHexChars(outHexChars),
	// LCD Side
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)
	);
endmodule
