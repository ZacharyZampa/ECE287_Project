module Bit_Converter (out, values);
		output [8:0]out;
		input [3:0]values;
		reg [8:0]out;
		
		always @ (*)
		begin
			if ( values > 4'd9)
				out = values + 9'h157;
			else
				out = values + 9'h130;
		end
endmodule
