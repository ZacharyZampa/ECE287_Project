module fFunction(r, subkey, foutput);
	input [31:0]r;
	input [47:0]subkey;
	output [31:0]foutput;
	
	wire [47:0]exP;
	wire [47:0]keyXexP;
	wire [47:0]preSBox;
	wire [47:0]postSBox;
	
	wire [3:0]n1, n2, n3, n4, n5, n6, n7, n8;


	// Expansion Permutation --------------------------------------------------------------
	assign exP = {r[0], r[31], r[30], r[29], r[28], r[27], 
						r[28], r[27], r[26], r[25], r[24], r[23], 
						r[24], r[23], r[22], r[21], r[20], r[19], 
						r[20], r[19], r[18], r[17], r[16], r[15], 
						r[16], r[15], r[14], r[13], r[12], r[11], 
						r[12], r[11], r[10], r[9], r[8], r[7], 
						r[8], r[7], r[6], r[5], r[4], r[3], 
						r[4], r[3], r[2], r[1], r[0], r[31]};
	// End Expansion Permutation ----------------------------------------------------------	
	
	assign keyXexP = subkey ^ exP; // xor add key and expanded r

	// mirror array: first bit on left side becomes first bit on right and so on
	assign preSBox = {keyXexP[0], keyXexP[1], keyXexP[2], keyXexP[3], keyXexP[4], keyXexP[5], keyXexP[6], keyXexP[7], 
				keyXexP[8], keyXexP[9], keyXexP[10], keyXexP[11], keyXexP[12], keyXexP[13], keyXexP[14], keyXexP[15], 
				keyXexP[16], keyXexP[17], keyXexP[18], keyXexP[19], keyXexP[20], keyXexP[21], keyXexP[22], keyXexP[23], 
				keyXexP[24], keyXexP[25], keyXexP[26], keyXexP[27], keyXexP[28], keyXexP[29], keyXexP[30], keyXexP[31],
				keyXexP[32], keyXexP[33], keyXexP[34], keyXexP[35], keyXexP[36], keyXexP[37], keyXexP[38], keyXexP[39],	
				keyXexP[40], keyXexP[41], keyXexP[42], keyXexP[43], keyXexP[44], keyXexP[45], keyXexP[46], keyXexP[47]};	
	
	
	
	// conduct s-box manipulation
	parameter S1 = {4'd14, 4'd4, 4'd13, 4'd1, 4'd2, 4'd15, 4'd11, 4'd8, 4'd3, 4'd10, 4'd6, 4'd12, 4'd5, 4'd9, 4'd0, 4'd7, 
						4'd0, 4'd15, 4'd7, 4'd4, 4'd14, 4'd2, 4'd13, 4'd1, 4'd10, 4'd6, 4'd12, 4'd11, 4'd9, 4'd5, 4'd3, 4'd8, 
						4'd4, 4'd1, 4'd14, 4'd8, 4'd13, 4'd6, 4'd2, 4'd11, 4'd15, 4'd12, 4'd9, 4'd7, 4'd3, 4'd10, 4'd5, 4'd0, 
						4'd15, 4'd12, 4'd8, 4'd2, 4'd4, 4'd9, 4'd1, 4'd7, 4'd5, 4'd11, 4'd3, 4'd14, 4'd10, 4'd0, 4'd6, 4'd13};

	parameter S2 = {4'd15, 4'd1, 4'd8, 4'd14, 4'd6, 4'd11, 4'd3, 4'd4, 4'd9, 4'd7, 4'd2, 4'd13, 4'd12, 4'd0, 4'd5, 4'd10, 
						4'd3, 4'd13, 4'd4, 4'd7, 4'd15, 4'd2, 4'd8, 4'd14, 4'd12, 4'd0, 4'd1, 4'd10, 4'd6, 4'd9, 4'd11, 4'd5, 
						4'd0, 4'd14, 4'd7, 4'd11, 4'd10, 4'd4, 4'd13, 4'd1, 4'd5, 4'd8, 4'd12, 4'd6, 4'd9, 4'd3, 4'd2, 4'd15, 
						4'd13, 4'd8, 4'd10, 4'd1, 4'd3, 4'd15, 4'd4, 4'd2, 4'd11, 4'd6, 4'd7, 4'd12, 4'd0, 4'd5, 4'd14, 4'd9 };

	parameter S3 = {4'd10, 4'd0, 4'd9, 4'd14, 4'd6, 4'd3, 4'd15, 4'd5, 4'd1, 4'd13, 4'd12, 4'd7, 4'd11, 4'd4, 4'd2, 4'd8, 
						4'd13, 4'd7, 4'd0, 4'd9, 4'd3, 4'd4, 4'd6, 4'd10, 4'd2, 4'd8, 4'd5, 4'd14, 4'd12, 4'd11, 4'd15, 4'd1, 
						4'd13, 4'd6, 4'd4, 4'd9, 4'd8, 4'd15, 4'd3, 4'd0, 4'd11, 4'd1, 4'd2, 4'd12, 4'd5, 4'd10, 4'd14, 4'd7, 
						4'd1, 4'd10, 4'd13, 4'd0, 4'd6, 4'd9, 4'd8, 4'd7, 4'd4, 4'd15, 4'd14, 4'd3, 4'd11, 4'd5, 4'd2, 4'd12 };

	parameter S4 = {4'd7, 4'd13, 4'd14, 4'd3, 4'd0, 4'd6, 4'd9, 4'd10, 4'd1, 4'd2, 4'd8, 4'd5, 4'd11, 4'd12, 4'd4, 4'd15, 
						4'd13, 4'd8, 4'd11, 4'd5, 4'd6, 4'd15, 4'd0, 4'd3, 4'd4, 4'd7, 4'd2, 4'd12, 4'd1, 4'd10, 4'd14, 4'd9, 
						4'd10, 4'd6, 4'd9, 4'd0, 4'd12, 4'd11, 4'd7, 4'd13, 4'd15, 4'd1, 4'd3, 4'd14, 4'd5, 4'd2, 4'd8, 4'd4, 
						4'd3, 4'd15, 4'd0, 4'd6, 4'd10, 4'd1, 4'd13, 4'd8, 4'd9, 4'd4, 4'd5, 4'd11, 4'd12, 4'd7, 4'd2, 4'd14 };

	parameter S5 = {4'd2, 4'd12, 4'd4, 4'd1, 4'd7, 4'd10, 4'd11, 4'd6, 4'd8, 4'd5, 4'd3, 4'd15, 4'd13, 4'd0, 4'd14, 4'd9, 
						4'd14, 4'd11, 4'd2, 4'd12, 4'd4, 4'd7, 4'd13, 4'd1, 4'd5, 4'd0, 4'd15, 4'd10, 4'd3, 4'd9, 4'd8, 4'd6, 
						4'd4, 4'd2, 4'd1, 4'd11, 4'd10, 4'd13, 4'd7, 4'd8, 4'd15, 4'd9, 4'd12, 4'd5, 4'd6, 4'd3, 4'd0, 4'd14, 
						4'd11, 4'd8, 4'd12, 4'd7, 4'd1, 4'd14, 4'd2, 4'd13, 4'd6, 4'd15, 4'd0, 4'd9, 4'd10, 4'd4, 4'd5, 4'd3 };

	parameter S6 = {4'd12, 4'd1, 4'd10, 4'd15, 4'd9, 4'd2, 4'd6, 4'd8, 4'd0, 4'd13, 4'd3, 4'd4, 4'd14, 4'd7, 4'd5, 4'd11, 
						4'd10, 4'd15, 4'd4, 4'd2, 4'd7, 4'd12, 4'd9, 4'd5, 4'd6, 4'd1, 4'd13, 4'd14, 4'd0, 4'd11, 4'd3, 4'd8, 
						4'd9, 4'd14, 4'd15, 4'd5, 4'd2, 4'd8, 4'd12, 4'd3, 4'd7, 4'd0, 4'd4, 4'd10, 4'd1, 4'd13, 4'd11, 4'd6, 
						4'd4, 4'd3, 4'd2, 4'd12, 4'd9, 4'd5, 4'd15, 4'd10, 4'd11, 4'd14, 4'd1, 4'd7, 4'd6, 4'd0, 4'd8, 4'd13 };

	parameter S7 = {4'd4, 4'd11, 4'd2, 4'd14, 4'd15, 4'd0, 4'd8, 4'd13, 4'd3, 4'd12, 4'd9, 4'd7, 4'd5, 4'd10, 4'd6, 4'd1, 
						4'd13, 4'd0, 4'd11, 4'd7, 4'd4, 4'd9, 4'd1, 4'd10, 4'd14, 4'd3, 4'd5, 4'd12, 4'd2, 4'd15, 4'd8, 4'd6, 
						4'd1, 4'd4, 4'd11, 4'd13, 4'd12, 4'd3, 4'd7, 4'd14, 4'd10, 4'd15, 4'd6, 4'd8, 4'd0, 4'd5, 4'd9, 4'd2, 
						4'd6, 4'd11, 4'd13, 4'd8, 4'd1, 4'd4, 4'd10, 4'd7, 4'd9, 4'd5, 4'd0, 4'd15, 4'd14, 4'd2, 4'd3, 4'd12 };

	parameter S8 = {4'd13, 4'd2, 4'd8, 4'd4, 4'd6, 4'd15, 4'd11, 4'd1, 4'd10, 4'd9, 4'd3, 4'd14, 4'd5, 4'd0, 4'd12, 4'd7, 
						4'd1, 4'd15, 4'd13, 4'd8, 4'd10, 4'd3, 4'd7, 4'd4, 4'd12, 4'd5, 4'd6, 4'd11, 4'd0, 4'd14, 4'd9, 4'd2, 
						4'd7, 4'd11, 4'd4, 4'd1, 4'd9, 4'd12, 4'd14, 4'd2, 4'd0, 4'd6, 4'd10, 4'd13, 4'd15, 4'd3, 4'd5, 4'd8, 
						4'd2, 4'd1, 4'd14, 4'd7, 4'd4, 4'd10, 4'd8, 4'd13, 4'd15, 4'd12, 4'd9, 4'd0, 4'd3, 4'd5, 4'd6, 4'd11 };

	
	assign n1 = S1[255 - {preSBox[0], preSBox[5], preSBox[1], preSBox[2], preSBox[3], preSBox[4]} * 4 -:4];
	assign n2 = S2[255 - {preSBox[6], preSBox[11], preSBox[7], preSBox[8], preSBox[9], preSBox[10]} * 4 -:4];
	assign n3 = S3[255 - {preSBox[12], preSBox[17], preSBox[13], preSBox[14], preSBox[15], preSBox[16]} * 4 -:4];
	assign n4 = S4[255 - {preSBox[18], preSBox[23], preSBox[19], preSBox[20], preSBox[21], preSBox[22]} * 4 -:4];
	assign n5 = S5[255 - {preSBox[24], preSBox[29], preSBox[25], preSBox[26], preSBox[27], preSBox[28]} * 4 -:4];
	assign n6 = S6[255 - {preSBox[30], preSBox[35], preSBox[31], preSBox[32], preSBox[33], preSBox[34]} * 4 -:4];
	assign n7 = S7[255 - {preSBox[36], preSBox[41], preSBox[37], preSBox[38], preSBox[39], preSBox[40]} * 4 -:4];
	assign n8 = S8[255 - {preSBox[42], preSBox[47], preSBox[43], preSBox[44], preSBox[45], preSBox[46]} * 4 -:4];


	
	// combine sbox outputs
	assign postSBox = {n8, n7, n6, n5, n4, n3, n2, n1};
	
	assign foutput = {postSBox[0], postSBox[1], postSBox[2], postSBox[3], postSBox[4], postSBox[5], postSBox[6], postSBox[7], 
				postSBox[8], postSBox[9], postSBox[10], postSBox[11], postSBox[12], postSBox[13], postSBox[14], postSBox[15], 
				postSBox[16], postSBox[17], postSBox[18], postSBox[19], postSBox[20], postSBox[21], postSBox[22], postSBox[23], 
				postSBox[24], postSBox[25], postSBox[26], postSBox[27], postSBox[28], postSBox[29], postSBox[30], postSBox[31]};
	
	// permute
	
	
	// revert array to original order (unmirror)
//	assign foutput = {postSBox[15], postSBox[6], postSBox[19], postSBox[20], 
//							postSBox[28], postSBox[11], postSBox[27], postSBox[16], 
//							postSBox[0], postSBox[14], postSBox[22], postSBox[25], 
//							postSBox[4], postSBox[17], postSBox[30], postSBox[9], 
//							postSBox[1], postSBox[7], postSBox[23], postSBox[13], 
//							postSBox[31], postSBox[26], postSBox[2], postSBox[8], 
//							postSBox[18], postSBox[12], postSBox[29], postSBox[5], 
//							postSBox[21], postSBox[10], postSBox[3], postSBox[24] };

// testing
	//assign foutput = postSBox;
							
							
							
	// current debugging process: 
	// f function should work up to postSbox
							
endmodule


				