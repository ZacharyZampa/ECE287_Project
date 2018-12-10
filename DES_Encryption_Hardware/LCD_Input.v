module LCD_Input(
  input in0, in1, in2, in3, loadButton, backspace, clear, rst,
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
  output [3:0] S // test output
	);

	//wire DLY_RST;
	//Reset_Delay r0(    .iCLK(CLOCK_50),.oRESET(DLY_RST) );

	assign    LCD_ON   = 1'b1;
	assign    LCD_BLON = 1'b1;
	
	parameter key = 64'h133457799BBCDFF1;
	
	
	// -------------------Instantiate Bit_Input Module----------------------
	wire [63:0] values;
	wire [4:0] nEntered;
	Bit_Input bits(values[63:0], in0,in1,in2,in3, loadButton, backspace, clear, rst, CLOCK_50, testRST, testLoad, testBackspace, testClear, nEntered, S);
	
	// -------------------Instantiate Module with the DES algorithm itself------
	wire [63:0] outValues;
	DES_Encrypter encrypter(values, key, outValues, decrypt);
	
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
	
	

	LCD_TEST u1(
	// Host Side
		.iCLK(CLOCK_50),
		.iRST_N(loadButton & backspace & clear),
		.realLetter(realLetter),
		.outHexChars(outHexChars),
	// LCD Side
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_EN(LCD_EN),
		.LCD_RS(LCD_RS)
	);
endmodule

module    LCD_TEST (
// Host Side
  input iCLK,iRST_N,
  input [143:0] realLetter, outHexChars,
// LCD Side
  output [7:0]     LCD_DATA,
  output LCD_RW,LCD_EN,LCD_RS    
);
//    Internal Wires/Registers
reg    [5:0]    LUT_INDEX;
reg    [8:0]    LUT_DATA;
reg    [5:0]    mLCD_ST;
reg    [17:0]    mDLY;
reg        mLCD_Start;
reg    [7:0]    mLCD_DATA;
reg        mLCD_RS;
wire        mLCD_Done;

parameter    LCD_INTIAL    =    0;
parameter    LCD_LINE1    =    5;
parameter    LCD_CH_LINE    =    LCD_LINE1+16;
parameter    LCD_LINE2    =    LCD_LINE1+16+1;
parameter    LUT_SIZE    =    LCD_LINE1+32+1;

always@(posedge iCLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        LUT_INDEX    <=    0;
        mLCD_ST        <=    0;
        mDLY        <=    0;
        mLCD_Start    <=    0;
        mLCD_DATA    <=    0;
        mLCD_RS        <=    0;
    end
    else
    begin
        if(LUT_INDEX<LUT_SIZE)
        begin
            case(mLCD_ST)
            0:    begin
                    mLCD_DATA    <=    LUT_DATA[7:0];
                    mLCD_RS        <=    LUT_DATA[8];
                    mLCD_Start    <=    1;
                    mLCD_ST        <=    1;
                end
            1:    begin
                    if(mLCD_Done)
                    begin
                        mLCD_Start    <=    0;
                        mLCD_ST        <=    2;                    
                    end
                end
            2:    begin
                    if(mDLY<18'h3FFFE)
                    mDLY    <=    mDLY + 1'b1;
                    else
                    begin
                        mDLY    <=    0;
                        mLCD_ST    <=    3;
                    end
                end
            3:    begin
                    LUT_INDEX    <=    LUT_INDEX + 1'b1;
                    mLCD_ST    <=    0;
                end
            endcase
        end
    end
end

always
begin
    case(LUT_INDEX)
    //    Initial
    LCD_INTIAL+0:    LUT_DATA    <=    9'h038;
    LCD_INTIAL+1:    LUT_DATA    <=    9'h00C;
    LCD_INTIAL+2:    LUT_DATA    <=    9'h001;
    LCD_INTIAL+3:    LUT_DATA    <=    9'h006;
    LCD_INTIAL+4:    LUT_DATA    <=    9'h080;
    //    Line 1
    LCD_LINE1+0:    LUT_DATA    <=    realLetter[143:135];    //First letter
    LCD_LINE1+1:    LUT_DATA    <=    realLetter[134:126];
    LCD_LINE1+2:    LUT_DATA    <=    realLetter[125:117];
    LCD_LINE1+3:    LUT_DATA    <=    realLetter[116:108];
    LCD_LINE1+4:    LUT_DATA    <=    realLetter[107:99];
    LCD_LINE1+5:    LUT_DATA    <=    realLetter[98:90];
    LCD_LINE1+6:    LUT_DATA    <=    realLetter[89:81];
    LCD_LINE1+7:    LUT_DATA    <=    realLetter[80:72];
    LCD_LINE1+8:    LUT_DATA    <=    realLetter[71:63];
    LCD_LINE1+9:    LUT_DATA    <=    realLetter[62:54];
    LCD_LINE1+10:    LUT_DATA    <=    realLetter[53:45];
    LCD_LINE1+11:    LUT_DATA    <=    realLetter[44:36];
    LCD_LINE1+12:    LUT_DATA    <=    realLetter[35:27];
    LCD_LINE1+13:    LUT_DATA    <=    realLetter[26:18];
    LCD_LINE1+14:    LUT_DATA    <=    realLetter[17:9];
    LCD_LINE1+15:    LUT_DATA    <=    realLetter[8:0];
    //    Change Line
    LCD_CH_LINE:    LUT_DATA    <=    9'h0C0;
    //    Line 2
    LCD_LINE2+0:    LUT_DATA    <=    outHexChars[143:135];   
    LCD_LINE2+1:    LUT_DATA    <=    outHexChars[134:126];
    LCD_LINE2+2:    LUT_DATA    <=    outHexChars[125:117];
    LCD_LINE2+3:    LUT_DATA    <=    outHexChars[116:108];
    LCD_LINE2+4:    LUT_DATA    <=    outHexChars[107:99];
    LCD_LINE2+5:    LUT_DATA    <=    outHexChars[98:90];
    LCD_LINE2+6:    LUT_DATA    <=    outHexChars[89:81];
    LCD_LINE2+7:    LUT_DATA    <=    outHexChars[80:72];
    LCD_LINE2+8:    LUT_DATA    <=    outHexChars[71:63];
    LCD_LINE2+9:    LUT_DATA    <=    outHexChars[62:54];
    LCD_LINE2+10:    LUT_DATA    <=    outHexChars[53:45];
    LCD_LINE2+11:    LUT_DATA    <=    outHexChars[44:36];
    LCD_LINE2+12:    LUT_DATA    <=    outHexChars[35:27];
    LCD_LINE2+13:    LUT_DATA    <=    outHexChars[26:18];
    LCD_LINE2+14:    LUT_DATA    <=    outHexChars[17:9];
    LCD_LINE2+15:    LUT_DATA    <=    outHexChars[8:0];
    default:        LUT_DATA    <=    9'dx;
    endcase
end

LCD_Controller u0(
//    Host Side
.iDATA(mLCD_DATA),
.iRS(mLCD_RS),
.iStart(mLCD_Start),
.oDone(mLCD_Done),
.iCLK(iCLK),
.iRST_N(iRST_N),
//    LCD Interface
.LCD_DATA(LCD_DATA),
.LCD_RW(LCD_RW),
.LCD_EN(LCD_EN),
.LCD_RS(LCD_RS)    );

endmodule

module LCD_Controller (    
//    Host Side
input [7:0] iDATA,
input iRS,
input iStart,
output reg oDone,
input iCLK,iRST_N,
//    LCD Interface
output [7:0] LCD_DATA,
output LCD_RW,
output reg LCD_EN,
output LCD_RS    );

parameter    CLK_Divide    =    16;

//    Internal Register
reg        [4:0]    Cont;
reg        [1:0]    ST;
reg        preStart,mStart;

/////////////////////////////////////////////
//    Only write to LCD, bypass iRS to LCD_RS
assign    LCD_DATA    =    iDATA; 
assign    LCD_RW        =    1'b0;
assign    LCD_RS        =    iRS;
/////////////////////////////////////////////

always@(posedge iCLK or negedge iRST_N)
begin
    if(!iRST_N)
    begin
        oDone    <=    1'b0;
        LCD_EN    <=    1'b0;
        preStart<=    1'b0;
        mStart    <=    1'b0;
        Cont    <=    0;
        ST        <=    0;
    end
    else
    begin
        //////    Input Start Detect ///////
        preStart<=    iStart;
        if({preStart,iStart}==2'b01)
        begin
            mStart    <=    1'b1;
            oDone    <=    1'b0;
        end
        //////////////////////////////////
        if(mStart)
        begin
            case(ST)
            0:    ST    <=    1;    //    Wait Setup
            1:    begin
                    LCD_EN    <=    1'b1;
                    ST        <=    2;
                end
            2:    begin                    
                    if(Cont<CLK_Divide)
                    Cont    <=    Cont + 1'b1;
                    else
                    ST        <=    3;
                end
            3:    begin
                    LCD_EN    <=    1'b0;
                    mStart    <=    1'b0;
                    oDone    <=    1'b1;
                    Cont    <=    0;
                    ST        <=    0;
                end
            endcase
        end
    end
end

endmodule

module Reset_Delay( input iCLK, output reg oRESET);
reg [19:0] Cont;

always@(posedge iCLK)
begin
    if(Cont!=20'hFFFFF)
    begin
        Cont <= Cont + 1'b1;
        oRESET <= 1'b0;
    end
    else
    oRESET <= 1'b1;
end


endmodule
