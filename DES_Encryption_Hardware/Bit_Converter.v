module Bit_Converter (out, values, show);
		output [8:0]out;
		input [3:0]values;
		input show; // if 1'b0, then show a space instead of the number
		reg [8:0]out;
		
		always @ (*)
		begin
			if (show == 1'b0)
				out = 9'h120;
			else if ( values > 4'd9)
				out = values + 9'h157;
			else
				out = values + 9'h130;
		end
endmodule
