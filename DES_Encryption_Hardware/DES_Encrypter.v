module DES_Encrypter(inValues, key, outValues, decrypt);
	input[63:0] inValues, key;
	output[63:0] outValues;
	input decrypt; // 1'b1 if the module should decrypt, rather than encrypt

	Subkey_Generator subkgen(key, subkey1, subkey2,subkey3,subkey4,subkey5,subkey6,subkey7,
				subkey8, subkey9, subkey10, subkey11, subkey12, subkey13, subkey14, subkey15, subkey16);
				
	wire [47:0]subkey1, subkey2,subkey3,subkey4,subkey5,subkey6,subkey7,
				subkey8, subkey9, subkey10, subkey11, subkey12, subkey13, subkey14, subkey15, subkey16;

	
	wire [31:0]foutput0, foutput1,foutput2,foutput3,foutput4,foutput5,foutput6, foutput7, 
				foutput8, foutput9, foutput10, foutput11, foutput12, foutput13, foutput14, foutput15;

	// l (left) and r (right)
	wire [31:0]l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12, l13, l14, l15, l16;
	wire [31:0]r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16;
				 
				 
		
	// define l0 and r0 -----------------------------------------------------------------
	assign l0 =	{inValues[6], inValues[14], inValues[22], inValues[30], inValues[38], inValues[46], inValues[54], inValues[62], 
					inValues[4], inValues[12], inValues[20], inValues[28], inValues[36], inValues[44], inValues[52], inValues[60], 
					inValues[2], inValues[10], inValues[18], inValues[26], inValues[34], inValues[42], inValues[50], inValues[58], 
					inValues[0], inValues[8], inValues[16], inValues[24], inValues[32], inValues[40], inValues[48], inValues[56]};

				
	assign r0 =	{inValues[7], inValues[15], inValues[23], inValues[31], inValues[39], inValues[47], inValues[55], inValues[63], 
					inValues[5], inValues[13], inValues[21], inValues[29], inValues[37], inValues[45], inValues[53], inValues[61], 
					inValues[3], inValues[11], inValues[19], inValues[27], inValues[35], inValues[43], inValues[51], inValues[59], 
					inValues[1], inValues[9], inValues[17], inValues[25], inValues[33], inValues[41], inValues[49], inValues[57]};

	// End define l0 and r0 -------------------------------------------------------------			
			
	// f fuctions -----------------------------------------------------------------------		
		fFunction f0(r0, subkey1, foutput0);
		fFunction f1(r1, subkey2, foutput1);
		fFunction f2(r2, subkey3, foutput2);
		fFunction f3(r3, subkey4, foutput3);
		fFunction f4(r4, subkey5, foutput4);
		fFunction f5(r5, subkey6, foutput5);
		fFunction f6(r6, subkey7, foutput6);
		fFunction f7(r7, subkey8, foutput7);
		fFunction f8(r8, subkey9, foutput8);
		fFunction f9(r9, subkey10, foutput9);
		fFunction f10(r10, subkey11, foutput10);
		fFunction f11(r11, subkey12, foutput11);
		fFunction f12(r12, subkey13, foutput12);
		fFunction f13(r13, subkey14, foutput13);
		fFunction f14(r14, subkey15, foutput14);
		fFunction f15(r15, subkey16, foutput15);
	// End f fuctions --------------------------------------------------------------------	
			
			
	// Switch r and l --------------------------------------------------------------------
		assign l1 = r0;
		assign l2 = r1;
		assign l3 = r2;
		assign l4 = r3;
		assign l5 = r4;
		assign l6 = r5;
		assign l7 = r6;
		assign l8 = r7;
		assign l9 = r8;
		assign l10 = r9;
		assign l11 = r10;
		assign l12 = r11;
		assign l13 = r12;
		assign l14 = r13;
		assign l15 = r14;
		assign l16 = r15;

		assign r1 = l0 ^ foutput0;
		assign r2 = l1 ^ foutput1;
		assign r3 = l2 ^ foutput2;
		assign r4 = l3 ^ foutput3;
		assign r5 = l4 ^ foutput4;
		assign r6 = l5 ^ foutput5;
		assign r7 = l6 ^ foutput6;
		assign r8 = l7 ^ foutput7;
		assign r9 = l8 ^ foutput8;
		assign r10 = l9 ^ foutput9;
		assign r11 = l10 ^ foutput10;
		assign r12 = l11 ^ foutput11;
		assign r13 = l12 ^ foutput12;
		assign r14 = l13 ^ foutput13;
		assign r15 = l14 ^ foutput14;
		assign r16 = l15 ^ foutput15;

	// End Switch r and l ------------------------------------------------------------------
	
	
	// final permutation
//		assign outValues = {l16[24], r16[24], l16[16], r16[16], l16[8], r16[8], l16[0], r16[0], 
//								l16[25], r16[25], l16[17], r16[17], l16[9], r16[9], l16[1], r16[1], 
//								l16[26], r16[26], l16[18], r16[18], l16[10], r16[10], l16[2], r16[2], 
//								l16[27], r16[27], l16[19], r16[19], l16[11], r16[11], l16[3], r16[3], 
//								l16[28], r16[28], l16[20], r16[20], l16[12], r16[12], l16[4], r16[4], 
//								l16[29], r16[29], l16[21], r16[21], l16[13], r16[13], l16[5], r16[5], 
//								l16[30], r16[30], l16[22], r16[22], l16[14], r16[14], l16[6], r16[6], 
//								l16[31], r16[31], l16[23], r16[23], l16[15], r16[15], l16[7], r16[7] };

		//assign outValues = r1;

			
assign outValues = foutput0; // temporary, for testing

endmodule
