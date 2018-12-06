module DES_Encrypter(inValues, key, outValues, decrypt);
input[63:0] inValues, key;
output[63:0] outValues;
input decrypt; // 1'b1 if the module should decrypt, rather than encrypt

assign outValues = key; // temporary, for testing

endmodule
