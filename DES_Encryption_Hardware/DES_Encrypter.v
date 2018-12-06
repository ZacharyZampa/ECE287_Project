module DES_Encrypter(inValues, key, outValues, decrypt);
input[63:0] inValues, key;
output[63:0] outValues;
input decrypt; // 1'b1 if the module should decrypt, rather than encrypt

Subkey_Generator subkgen(key, subkey0, subkey1, subkey2,subkey3,subkey4,subkey5,subkey6,subkey7,
			subkey8, subkey9, subkey10, subkey11, subkey12, subkey13, subkey14, subkey15, keyCheck);
			
wire [47:0]subkey0, subkey1, subkey2,subkey3,subkey4,subkey5,subkey6,subkey7,
			subkey8, subkey9, subkey10, subkey11, subkey12, subkey13, subkey14, subkey15;
wire [63:0]keyCheck;
			
			
			
assign outValues = keyCheck; // temporary, for testing

endmodule
