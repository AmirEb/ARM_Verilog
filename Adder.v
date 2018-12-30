module Adder #(parameter n = 64) (input1, input2, outputdata);
	
	input [n - 1 : 0] input1, input2;
	output[n - 1 : 0] outputdata;

	assign output_data = input1 + input2;

endmodule
