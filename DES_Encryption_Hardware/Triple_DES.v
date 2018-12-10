module Triple_DES(inValues0, key1, key2, outValues, decrypt);
	input[63:0] inValues0, key1, key2;
	output[63:0] outValues;
	input decrypt; // 1'b1 if the module should decrypt, rather than encrypt
	
	wire [63:0] inValues0, key1, key2, inValues1, inValues2;
	
	DES_Encrypter DES_Stage1(inValues0, key1, outValues0, decrypt);
	wire [63:0]outValues0;
	assign inValues1 = outValues0;
	DES_Encrypter DES_Stage2(inValues1, key2, outValues1, !decrypt);
	wire [63:0]outValues1;
	assign inValues2 = outValues1;
	DES_Encrypter DES_Stage3(inValues2, key1, outValues2, decrypt);
	wire [63:0]outValues2;
	assign outValues = outValues2;

	
endmodule
	
	